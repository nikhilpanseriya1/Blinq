import 'dart:io';

import 'package:blinq/Utility/utility_export.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../Utility/constants.dart';
import '../Authentication/start_screen.dart';
import 'edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> userSetup(String displayName) async {
    DatabaseReference taskRef = FirebaseDatabase.instance.ref().child('users').child('uid');

    // String taskId = taskRef.push().key;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setIsLogin(isLogin: true);
  }

  @override
  Widget build(BuildContext context) {
    return commonStructure(
        context: context,
        appBar: commonAppBar(title: 'Work', actionWidgets: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                color: colorPrimary,
                size: 22,
              )),
          IconButton(
              onPressed: () {
                Get.to(() => EditScreen());
              },
              icon: const Icon(
                Icons.edit,
                color: colorPrimary,
                size: 22,
              )),
          IconButton(
              onPressed: () {
                setIsLogin(isLogin: false);
                Get.offAll(() => StartScreen());
              },
              icon: const Icon(
                Icons.logout,
                color: colorPrimary,
                size: 22,
              ))
        ]),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.heightBox,
              Center(
                child: QrImage(
                  data: "Jevalino 1234567890",
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              20.heightBox,
              Obx(
                () => SizedBox(
                  height: getScreenHeight(context) * 0.30,
                  child: Stack(
                    children: [
                      Container(
                        height: getScreenHeight(context) * 0.25,
                        width: getScreenWidth(context),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), boxShadow: [
                          BoxShadow(color: colorGrey.withOpacity(0.5), offset: const Offset(0.0, 3.0), blurRadius: 10)
                        ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image(
                            fit: BoxFit.cover,
                            image: kAuthenticationController.selectedCompanyLogo.value.isNotEmpty
                                ? FileImage(File(kAuthenticationController.selectedCompanyLogo.value)) as ImageProvider
                                : bgPlaceholder,
                          ),
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
                              boxShadow: const [BoxShadow(color: colorGrey, offset: Offset(0.0, 3.0), blurRadius: 10)]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image(
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              image: kAuthenticationController.selectedImage.value.isNotEmpty
                                  ? FileImage(File(kAuthenticationController.selectedImage.value)) as ImageProvider
                                  : profilePlaceholder,
                            ),
                            // backgroundImage: userProfile2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              10.heightBox,
              Text('Developer', style: FontStyleUtility.blackInter22W400),
              10.heightBox,
              Text('IT Department', style: FontStyleUtility.blackInter22W400),
              10.heightBox,
              Text('Google', style: FontStyleUtility.blackInter22W400),
            ],
          ),
        ),
        floatingButton: FloatingActionButton.extended(
          backgroundColor: colorPrimary,
          onPressed: () {},
          label: Text(
            'SEND',
            style: FontStyleUtility.blackInter16W500.copyWith(color: colorWhite),
          ),
          icon: const Icon(Icons.send),
        ));
  }
}
