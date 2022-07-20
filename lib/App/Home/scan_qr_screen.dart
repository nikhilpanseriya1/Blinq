import 'dart:developer';
import 'dart:io';

import 'package:blinq/Utility/utility_export.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../Utility/constants.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isValidQr = true;
  var userContactData;

  var addNewContact;

  RxBool addUserCall = false.obs;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 3, child: _buildQrView(context)),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // if (result != null)
                //   Text('Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                // else
                //   const Text('Scan a code'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 75,
                        width: 75,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: colorPrimary.withOpacity(0.3), borderRadius: BorderRadius.circular(100)),
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(fixedSize: const Size(50, 50), shape: CircleBorder()),
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: Container(
                              child: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  return Icon(
                                    snapshot.data == false ? Icons.flashlight_off : Icons.flashlight_on,
                                    size: 20,
                                  );
                                  // return Text('Flash: ${snapshot.data}');
                                },
                              ),
                            )),
                      ),
                    ),
                    Container(
                      height: 75,
                      width: 75,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration:
                          BoxDecoration(color: colorPrimary.withOpacity(0.3), borderRadius: BorderRadius.circular(100)),
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(fixedSize: const Size(50, 50), shape: CircleBorder()),
                          onPressed: () async {
                            await controller?.flipCamera();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getCameraInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null)
                                return Icon(
                                  Icons.switch_camera,
                                  size: 20,
                                );
                              else
                                return SizedBox();
                              // if (snapshot.data != null) {
                              //   return Text(
                              //       'Camera facing ${describeEnum(snapshot.data!)}');
                              // } else {
                              //   return const Text('loading');
                              // }
                            },
                          )),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller?.resumeCamera();
                        },
                        child: Text('Resume', style: FontStyleUtility.blackInter16W600.copyWith(color: colorWhite)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller?.pauseCamera();
                        },
                        child: Text('Pause', style: FontStyleUtility.blackInter16W600.copyWith(color: colorWhite)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea =
        (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    // setState(() {
    this.controller = controller;
    // });
    List<String> contactsId = [];
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;

      if (result != null) {
        String sharedCardId = result!.code.toString();
        // String sharedCardId = '2rUK0sPS6PUrHFvByKabWm9RyGv2';

        // userContactData = FirebaseFirestore.instance.doc('users/$sharedCardId');

        try {
          if (isValidQr) {
            if (kHomeController.mainUserData['contacts'].isNotEmpty) {
              kHomeController.userContacts.clear();
              kHomeController.mainUserData['contacts'].forEach((element) {
                /// for check is already exist or not
                if (!contactsId.contains(element['id'])) {
                  contactsId.add(element['id']);
                }

                /// add contacts data
                kHomeController.userContacts.add({
                  'id': element['id'],
                  'profile_pic': element['profile_pic'],
                  'first_name': element['first_name'],
                  'last_name': element['last_name'],
                  'job_title': element['job_title'],
                  'company_name': element['company_name']
                });
              });
            }

            showLog('=====>>>> ${contactsId.contains(sharedCardId)}');
            showLog('=====>>>> ${contactsId}');
            showLog('=====>>>> ${sharedCardId}');

            if (contactsId.contains(sharedCardId)) {
              // showSnackBar(message: 'You already added this contact', color: Colors.red);
              myToast(
                  message: 'You already added this contact!',
                  bgColor: Colors.red,
                  textColor: colorWhite,
                  toastLength: Toast.LENGTH_LONG);
              isValidQr = false;
              Get.back();
              return;
            } else {
              /// Add New Contact

              isValidQr = false;

              FirebaseFirestore.instance.collection('users').doc(sharedCardId).get().then((value) {
                kHomeController.userContacts.add({
                  'id': sharedCardId,
                  'profile_pic': value['profile_pic'],
                  'first_name': value['first_name'],
                  'last_name': value['last_name'],
                  'job_title': value['job_title'],
                  'company_name': value['company_name']
                });

                if (kHomeController.userContacts.isNotEmpty) {
                  kHomeController.userRef.update({'contacts': kHomeController.userContacts}).whenComplete(() async {
                    kHomeController.getContacts = true;
                    myToast(
                        message: 'Contact added successfully...',
                        bgColor: colorGreen,
                        textColor: colorWhite,
                        toastLength: Toast.LENGTH_LONG);
                    // isValidQr = false;
                    Get.back();
                    showLog('contact added successfully...');
                    // callBack();
                  });
                }
              });
            }
          }
          // Get.back();
          return;
        } catch (e) {
          print(e);
        }
      }
      // setState(() {
      //   result = scanData;
      // });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

/* Widget addNewContactData({required String cardId, required Function callBack}) {
    // addNewContact = FirebaseFirestore.instance.collection('users/$cardId').snapshots();
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users/$cardId').snapshots(),
      builder: (context, snapshot) {
        try {
          if (snapshot.hasError) {
            return StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return Center(child: Text('Something went wrong'));
                });
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: (Text('Loading...')));
          }

          userContactData = snapshot.requireData;

          kHomeController.userContacts.add({
            'id': result!.code.toString(),
            'profile_pic': userContactData['profile_pic'],
            'first_name': userContactData['first_name'],
            'last_name': userContactData['last_name'],
            'job_title': userContactData['job_title'],
            'company_name': userContactData['company_name']
          });

          // kHomeController.userContacts.add(sharedCardId);
          if (kHomeController.userContacts.isNotEmpty) {
            kHomeController.userRef.update({'contacts': kHomeController.userContacts}).whenComplete(() async {
              kHomeController.getContacts = true;
              isValidQr = false;
              myToast(
                  message: 'Contact added successfully...',
                  bgColor: colorGreen,
                  textColor: colorWhite,
                  toastLength: Toast.LENGTH_LONG);
              showLog('contact added successfully...');
              // callBack();
            });
          }
        } catch (e) {
          showLog(e);
        }

        // if (kHomeController.getSubCards) {
        //   if (userData['cards'].isNotEmpty) {
        //     cards.clear();
        //     userData['cards'].forEach((element) {
        //       cards.add(element);
        //     });
        //     cards.refresh();
        //     showLog('~~~~~~~ $cards');
        //     kHomeController.getSubCards = false;
        //   }
        // }
        return SizedBox();

        // final userDoc = await usersCollection.doc(userId).get();
      },
    );
  }*/
}
