import 'package:blinq/App/Home/edit_screen.dart';
import 'package:blinq/App/Home/share_screen.dart';
import 'package:blinq/App/Home/your_card_screen.dart';
import 'package:blinq/Utility/utility_export.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../Utility/constants.dart';

class ViewContactScreen extends StatefulWidget {
  String contactCardId;

  ViewContactScreen({Key? key, required this.contactCardId}) : super(key: key);

  @override
  State<ViewContactScreen> createState() => _ViewContactScreenState();
}

class _ViewContactScreenState extends State<ViewContactScreen> {
  var contactCardDetails;

  RxBool isDocExist = false.obs;
  String loadingMsg = 'Loading...';
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkIfDocExists(widget.contactCardId);
  }

  /// Check If Document Exists
  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('users');
      var doc = await collectionRef.doc(docId).get();

      isDocExist.value = doc.exists;

      if (!isDocExist.value) {
        loadingMsg = 'This card has been deleted by creator..!';
      }
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => commonStructure(
        context: context,
        appBar: commonAppBar(),
        child: isDocExist.value
            ? StreamBuilder<Object>(
                stream: FirebaseFirestore.instance.collection('users').doc(widget.contactCardId).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong, Please try again later...'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: (Text('Loading...')));
                  }
                  contactCardDetails = snapshot.requireData;

                  updateCardDate(contactCardDetails);

                  return SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.heightBox,
                        Center(
                          child: RepaintBoundary(
                            key: globalKey,
                            child: QrImage(
                              data: widget.contactCardId,
                              backgroundColor: colorWhite,
                              version: QrVersions.auto,
                              size: 200.0,
                            ),
                          ),
                        ),
                        20.heightBox,
                        SizedBox(
                          height: getScreenHeight(context) * 0.30,
                          child: Stack(
                            children: [
                              Container(
                                height: getScreenHeight(context) * 0.25,
                                width: getScreenWidth(context),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [BoxShadow(color: colorGrey.withOpacity(0.5), offset: const Offset(0.0, 3.0), blurRadius: 10)]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: contactCardDetails['profile_pic'] == null || contactCardDetails['profile_pic'].toString().isEmpty
                                      ? Container(
                                          height: 55,
                                          width: 55,
                                          color: colorRed,
                                        )
                                      : CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: contactCardDetails['company_logo'],
                                          placeholder: (context, url) => Image(
                                            image: bgPlaceholder,
                                            fit: BoxFit.cover,
                                          ),
                                          errorWidget: (context, url, error) => Image(
                                            image: bgPlaceholder,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  margin: const EdgeInsets.only(right: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: const [BoxShadow(color: colorGrey, offset: Offset(0.0, 3.0), blurRadius: 10)]),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: contactCardDetails['profile_pic'] == null || contactCardDetails['profile_pic'].toString().isEmpty
                                        ? Image(
                                            image: profilePlaceholder,
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                            imageUrl: contactCardDetails['profile_pic'],
                                            placeholder: (context, url) => Image(
                                              image: profilePlaceholder,
                                              fit: BoxFit.cover,
                                            ),
                                            errorWidget: (context, url, error) => Image(
                                              image: profilePlaceholder,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        10.heightBox,
                        Text(
                          '${contactCardDetails['first_name']} ${contactCardDetails['last_name']}',
                          style: FontStyleUtility.blackInter16W600.copyWith(fontSize: 24),
                        ),
                        10.heightBox,
                        Text(contactCardDetails['job_title'], style: FontStyleUtility.blackInter16W500),
                        10.heightBox,
                        Text(contactCardDetails['department'], style: FontStyleUtility.blackInter16W500),
                        10.heightBox,
                        Text(contactCardDetails['company_name'], style: FontStyleUtility.blackInter16W500),
                        contactCardDetails['headline'].isNotEmpty
                            ? Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(contactCardDetails['headline'], style: FontStyleUtility.greyInter16W400))
                            : SizedBox.shrink(),
                        10.heightBox,
                        Divider(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: contactCardDetails['fields'].length ?? 0,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () async {
                                String type = getFieldType(fileTitle: contactCardDetails['fields'][index]['title']);

                                if (type == typeEmail) {
                                  openMail(emailAddress: contactCardDetails['fields'][index]['data']);
                                } else if (type == typePhone) {
                                  final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: contactCardDetails['fields'][index]['data'],
                                  );
                                  await launchUrl(launchUri);
                                } else if (type == typeLink) {
                                  const url = "https://flutter.io";
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url));
                                  } else {
                                    // can't launch url, there is some error
                                    throw "Could not launch $url";
                                  }
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                height: 50,
                                width: 50,
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(100)),
                                child: Image(
                                  image: getImage(index: index, fieldName: contactCardDetails['fields'][index]['title']),
                                  color: colorWhite,
                                ),
                              ),
                              title: Text(
                                contactCardDetails['fields'][index]['data'],
                                style: FontStyleUtility.blackInter16W500,
                              ),
                              subtitle: Text(
                                contactCardDetails['fields'][index]['label'],
                                style: FontStyleUtility.greyInter14W400,
                              ),
                            );
                          },
                        ),
                        50.heightBox,
                      ],
                    ),
                  );
                })
            : Container(
                child: Center(
                  child: Text(
                    loadingMsg,
                  ),
                ),
              ),
        floatingButton: FloatingActionButton.extended(
          backgroundColor: colorPrimary,
          onPressed: () {
            GlobalKey shareQrKey = GlobalKey();
            showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                context: context,
                builder: (context) {
                  return Container(
                    height: getScreenHeight(context) * 0.9,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)), color: colorPrimary),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            height: 5,
                            width: 100,
                            decoration: BoxDecoration(color: colorWhite, borderRadius: BorderRadius.circular(100)),
                          ),
                          20.heightBox,
                          Expanded(
                            child: SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      height: 225,
                                      width: 225,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                                      child: RepaintBoundary(
                                        key: shareQrKey,
                                        child: QrImage(
                                          backgroundColor: colorWhite,
                                          foregroundColor: colorBlack,
                                          data: widget.contactCardId,
                                          version: QrVersions.auto,
                                          size: 225,
                                        ),
                                      ),
                                    ),
                                  ),
                                  20.heightBox,
                                  Text(
                                    'Point your camera at the QR\ncode to receive the card',
                                    style: FontStyleUtility.blackInter22W700.copyWith(color: colorWhite),
                                    textAlign: TextAlign.center,
                                  ),
                                  20.heightBox,
                                  commonSheetRow(
                                      callBack: () {
                                        Clipboard.setData(ClipboardData(
                                            text:
                                                '${kHomeController.currentUserData['first_name']} ${kHomeController.currentUserData['last_name']}\'s $appName card. Copy this id and add card on $appName \n\n ${widget.contactCardId}'));

                                        myToast(message: 'Copy card');
                                      },
                                      icon: Icons.copy,
                                      name: 'Copy link'),
                                  commonSheetRow(
                                      callBack: () {
                                        Get.back();
                                        Get.to(() => ShareScreen(cardId: widget.contactCardId));
                                      },
                                      icon: Icons.message,
                                      name: 'Text your card'),
                                  commonSheetRow(
                                      callBack: () {
                                        openMail(
                                            emailAddress: widget.contactCardId,
                                            msg:
                                                '${kHomeController.currentUserData['first_name']} ${kHomeController.currentUserData['last_name']}\'s $appName card. Copy this id and add card on $appName \n\n ${widget.contactCardId}');
                                      },
                                      icon: Icons.email,
                                      name: 'Mail your card'),
                                  commonSheetRow(
                                      callBack: () async {
                                        await Share.share(
                                          '${kHomeController.currentUserData['first_name']} ${kHomeController.currentUserData['last_name']}\'s $appName card. Copy this id and add card on $appName \n\n ${widget.contactCardId}', /* subject: '${userData['first_name']} ${userData['last_name']}\'s $appName card.'*/
                                        );
                                      },
                                      icon: Icons.more_horiz,
                                      name: 'Send another way'),
                                  Divider(color: colorWhite.withOpacity(0.5)),
                                  commonSheetRow(
                                      callBack: () {
                                        SaveQRImage(isDownloadImage: true, globalKey: shareQrKey);
                                      },
                                      iconWidget: Image(image: photos, height: 25, width: 25),
                                      name: 'Save QR code to photos'),
                                  commonSheetRow(
                                      callBack: () {
                                        SaveQRImage(isDownloadImage: false, globalKey: shareQrKey);
                                      },
                                      icon: Icons.send,
                                      name: 'Send QR code'),
                                  10.heightBox,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          label: Text(
            'Send',
            style: FontStyleUtility.blackInter16W500.copyWith(color: colorWhite),
          ),
          icon: const Icon(Icons.send),
        ),
      ),
    );
  }

  Widget commonSheetRow({required Function() callBack, IconData? icon, required String name, Widget? iconWidget}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        splashColor: colorWhite,
        highlightColor: colorWhite,
        onTap: () {
          callBack();
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(color: colorBlack.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              15.widthBox,
              iconWidget ??
                  Icon(
                    icon,
                    color: colorWhite,
                  ),
              15.widthBox,
              Text(
                name,
                style: FontStyleUtility.blackInter16W500.copyWith(color: colorWhite),
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateCardDate(contactCardDetails) {
    kHomeController.userContacts.forEach((element) async {
      if (widget.contactCardId == element['id']) {
        if (element['profile_pic'] != contactCardDetails['profile_pic'] ||
            element['first_name'] != contactCardDetails['first_name'] ||
            element['last_name'] != contactCardDetails['last_name'] ||
            element['job_title'] != contactCardDetails['job_title'] ||
            element['company_name'] != contactCardDetails['company_name']) {
          //
          // update data if value updated
          //
          kHomeController.userContacts.remove(element);
          kHomeController.userContacts.add({
            'id': widget.contactCardId,
            'profile_pic': contactCardDetails['profile_pic'],
            'first_name': contactCardDetails['first_name'],
            'last_name': contactCardDetails['last_name'],
            'job_title': contactCardDetails['job_title'],
            'company_name': contactCardDetails['company_name']
          });
          await FirebaseFirestore.instance
              .doc('users/${kAuthenticationController.userId}')
              .set({'contacts': kHomeController.userContacts}, SetOptions(merge: true));
          /*.whenComplete(() {
          List<Map<String, dynamic>> tempArray = kHomeController.userContacts.reversed.toList();
          kHomeController.userContacts.value = tempArray;
          kHomeController.userContacts.refresh();
        });*/
        }
      }
    });
  }
}
