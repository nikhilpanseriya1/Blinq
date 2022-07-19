import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:blinq/App/Authentication/start_screen.dart';
import 'package:blinq/App/Home/edit_screen.dart';
import 'package:blinq/App/Home/home_screen.dart';
import 'package:blinq/Utility/constants.dart';
import 'package:blinq/Utility/utility_export.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class YourCardScreen extends StatefulWidget {
  const YourCardScreen({Key? key}) : super(key: key);

  @override
  State<YourCardScreen> createState() => _YourCardScreenState();
}

class _YourCardScreenState extends State<YourCardScreen> {
  RxInt currentIndex = 0.obs;
  RxList<String> cards = [''].obs;

  GlobalKey globalKey = GlobalKey();

  var currentUserSnap =
      FirebaseFirestore.instance.collection('users').doc(kAuthenticationController.userId).snapshots();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return commonStructure(
      context: context,
      appBar: commonAppBar(title: 'Your Card', actionWidgets: [
        IconButton(
            onPressed: () {
              Get.to(() => EditScreen(
                    isFromEdit: false,
                    cardId: kAuthenticationController.userId,
                  ));
            },
            icon: const Icon(
              Icons.add,
              color: colorPrimary,
              size: 22,
            )),
        IconButton(
            onPressed: () {
              Get.to(() => EditScreen(isFromEdit: true, cardId: cards[currentIndex.value]));
            },
            icon: const Icon(
              Icons.edit,
              color: colorPrimary,
              size: 22,
            )),
        IconButton(
            onPressed: () async {
              try {
                setIsLogin(isLogin: false);
                Get.offAll(() => StartScreen());
                await kAuthenticationController.userAuthentication.signOut();
              } catch (error) {
                print(error.toString());
              }
            },
            icon: const Icon(
              Icons.logout,
              color: colorPrimary,
              size: 22,
            ))
      ]),
      child: StreamBuilder<Object>(
          stream: currentIndex.stream,
          builder: (context, snapshot) {
            return PageView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: cards.length,
              onPageChanged: (index) {
                currentIndex.value = index;

                currentUserSnap =
                    FirebaseFirestore.instance.collection('users').doc(cards[currentIndex.value]).snapshots();
                currentIndex.refresh();
                // setState(() {});
                print('asdhahsdiuasiudas $index');
              },
              itemBuilder: (BuildContext context, int index) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: StreamBuilder(
                    stream: currentUserSnap,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Something went wrong'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: (Text('Loading...')));
                      }

                      userData = snapshot.requireData;

                      if (kHomeController.getSubCards) {
                        if (userData['cards'].isNotEmpty) {
                          cards.clear();
                          userData['cards'].forEach((element) {
                            cards.add(element);
                          });
                          cards.refresh();
                          showLog('~~~~~~~ $cards');
                          kHomeController.getSubCards = false;
                        }
                      }

                      // final userDoc = await usersCollection.doc(userId).get();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          30.heightBox,
                          Center(
                            child: RepaintBoundary(
                              key: globalKey,
                              child: Obx(
                                () => QrImage(
                                  data: cards[currentIndex.value],
                                  backgroundColor: colorWhite,
                                  version: QrVersions.auto,
                                  size: 200.0,
                                ),
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
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), boxShadow: [
                                    BoxShadow(
                                        color: colorGrey.withOpacity(0.5),
                                        offset: const Offset(0.0, 3.0),
                                        blurRadius: 10)
                                  ]),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: userData['company_logo'],
                                      placeholder: (context, url) => Image(
                                        image: bgPlaceholder,
                                        fit: BoxFit.cover,
                                      ),
                                      errorWidget: (context, url, error) => Image(
                                        image: bgPlaceholder,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // child: Image(
                                    //   fit: BoxFit.cover,
                                    //   image: kAuthenticationController.selectedCompanyLogo.value.isNotEmpty
                                    //       ? FileImage(File(kAuthenticationController.selectedCompanyLogo.value))
                                    //           as ImageProvider
                                    //       : bgPlaceholder,
                                    // ),
                                    // backgroundImage: userProfile2,
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
                                        boxShadow: const [
                                          BoxShadow(color: colorGrey, offset: Offset(0.0, 3.0), blurRadius: 10)
                                        ]),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                        imageUrl: userData['profile_pic'],
                                        placeholder: (context, url) => Image(
                                          image: profilePlaceholder,
                                          fit: BoxFit.cover,
                                        ),
                                        errorWidget: (context, url, error) => Image(
                                          image: profilePlaceholder,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // child: Image(
                                      //   height: 100,
                                      //   width: 100,
                                      //   fit: BoxFit.cover,
                                      //   image: kAuthenticationController.selectedImage.value.isNotEmpty
                                      //       ? FileImage(File(kAuthenticationController.selectedImage.value)) as ImageProvider
                                      //       : profilePlaceholder,
                                      // ),
                                      // backgroundImage: userProfile2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          10.heightBox,
                          Text(
                            '${userData['first_name']} ${userData['last_name']}',
                            style: FontStyleUtility.blackInter16W600.copyWith(fontSize: 30),
                          ),
                          10.heightBox,
                          Text(userData['job_title'], style: FontStyleUtility.blackInter22W400),
                          10.heightBox,
                          Text(userData['department'], style: FontStyleUtility.blackInter22W400),
                          10.heightBox,
                          Text(userData['company_name'], style: FontStyleUtility.blackInter22W400),
                          userData['headline'].isNotEmpty
                              ? Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(userData['headline'], style: FontStyleUtility.greyInter16W400))
                              : SizedBox.shrink(),
                          10.heightBox,
                          Divider(),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: userData['fields'].length ?? 0,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () async {
                                  String type = getFieldType(fileTitle: userData['fields'][index]['title']);

                                  if (type == typeEmail) {
                                    openMail(emailAddress: userData['fields'][index]['data']);
                                  } else if (type == typePhone) {
                                    final Uri launchUri = Uri(
                                      scheme: 'tel',
                                      path: userData['fields'][index]['data'],
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
                                  decoration:
                                      BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(100)),
                                  child: Image(
                                    image: getImage(index: index, fieldName: userData['fields'][index]['title']),
                                    color: colorWhite,
                                  ),
                                ),
                                title: Text(
                                  userData['fields'][index]['data'],
                                  style: FontStyleUtility.blackInter16W500,
                                ),
                                subtitle: Text(
                                  userData['fields'][index]['label'],
                                  style: FontStyleUtility.greyInter14W400,
                                ),
                              );
                            },
                          ),
                          50.heightBox,
                        ],
                      );
                    },
                  ),
                );
              },
            );
          }),
      floatingButton: FloatingActionButton.extended(
        backgroundColor: colorPrimary,
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
              context: context,
              builder: (context) {
                return Container(
                  height: getScreenHeight(context) * 0.9,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                      color: colorPrimary),
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
                                    child: QrImage(
                                      backgroundColor: colorWhite,
                                      foregroundColor: colorBlack,
                                      data: cards[currentIndex.value],
                                      version: QrVersions.auto,
                                      size: 225,
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
                                commonSheetRow(callBack: () {}, icon: Icons.copy, name: 'Copy link'),
                                commonSheetRow(callBack: () {}, icon: Icons.message, name: 'Text your card'),
                                commonSheetRow(callBack: () {}, icon: Icons.email, name: 'Mail your card'),
                                // commonSheetRow(
                                //     callBack: () {},
                                //     iconWidget: Image(image: whatsappShare, height: 25, width: 25),
                                //     name: 'Send via WhatsApp'),
                                // commonSheetRow(
                                //     callBack: () {},
                                //     iconWidget: Image(image: linkedinShare, height: 25, width: 25),
                                //     name: 'Send via LinkedIn'),
                                commonSheetRow(
                                    callBack: () async {
                                      await Share.share(cards[currentIndex.value],
                                          subject: 'Chintu Patel\'s Blinq card');
                                    },
                                    icon: Icons.more_horiz,
                                    name: 'Send another way'),
                                // Divider(color: colorWhite.withOpacity(0.5)),
                                // commonSheetRow(
                                //     callBack: () {},
                                //     iconWidget: Image(image: linkedinShare, height: 25, width: 25),
                                //     name: 'Post to LinkedIn'),
                                // commonSheetRow(
                                //     callBack: () {},
                                //     iconWidget: Image(image: facebookShare, height: 25, width: 25),
                                //     name: 'Post to Facebook'),
                                Divider(color: colorWhite.withOpacity(0.5)),
                                commonSheetRow(
                                    callBack: () {
                                      SaveQRImage(isDownloadImage: true, globalKey: globalKey);
                                    },
                                    iconWidget: Image(image: photos, height: 25, width: 25),
                                    name: 'Save QR code to photos'),
                                commonSheetRow(callBack: () {}, icon: Icons.send, name: 'Send QR code'),
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


}

openMail({required emailAddress}) async {
  try {
    launch("mailto:<$emailAddress>");
  } catch (e) {
    showLog('====---- $e');
  }
}

void SaveQRImage({required bool isDownloadImage, required GlobalKey globalKey}) async {
  try {
    // final RenderRepaintBoundary boundary = globalKey.currentContext?.findRenderObject();
    RenderRepaintBoundary? boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    final ui.Image? image = await boundary?.toImage();
    final ByteData? byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    // print(pngBytes);

    final tempDir = await getApplicationDocumentsDirectory();
    final file = await File('${tempDir.path}/${DateTime.now()}.png').create();
    File file1 = await file.writeAsBytes(pngBytes);
    if (isDownloadImage) {
      myToast(message: 'Image Saved Successfully!', bgColor: colorWhite);
    } else {
      await Share.shareFiles([file1.path]);
    }
  } catch (e) {
    print(e);
  }
}

String getFieldType({required String fileTitle}) {
  return fileTitle == 'Phone Number' || fileTitle == 'Signal' || fileTitle == 'WhatsApp'
      ? typePhone
      : fileTitle == 'Email'
          ? typeEmail
          : fileTitle == 'Location' || fileTitle == 'Skype'
              ? typeString
              : typeLink;
}
