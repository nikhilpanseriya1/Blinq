import 'dart:io';

import 'package:blinq/App/Home/add_field_screen.dart';
import 'package:blinq/Utility/constants.dart';
import 'package:blinq/Utility/utility_export.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Authentication/stepper_screen.dart';
import 'home_screen.dart';

String temporaryUid = 'o0kTb1NmrIMwih3joqUW';

class EditScreen extends StatefulWidget {
  bool isFromEdit;

  EditScreen({Key? key, required this.isFromEdit}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  RxBool branding = true.obs;
  RxBool logoToQr = false.obs;
  RxBool metField = false.obs;
  RxBool isProfileChanged = false.obs;
  RxBool isLogoChanged = false.obs;

  String companyLogoUrl = '';
  String profilePicUrl = '';

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController departmentNameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController headlineController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  Future uploadFile({required String filePath, required bool isProfile, required Function() callBack}) async {
    File file = File(filePath);

    final fileName = DateTime.now();
    final destination;
    isProfile ? destination = 'UserProfile/profilePic$fileName' : destination = 'UserProfile/companyLogo$fileName';
    // task = FirebaseApi.uploadFile(destination, file!);
    // setState(() {});
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      final snapshot = await ref.putFile(file).whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      isProfile ? companyLogoUrl = urlDownload : profilePicUrl = urlDownload;

      callBack();
      print('Download-Link: $urlDownload');
    } on FirebaseException catch (e) {
      showLog(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.isFromEdit) {
      firstNameController.text = userData['first_name'];
      lastNameController.text = userData['last_name'];
      jobTitleController.text = userData['jon_title'];
      departmentNameController.text = userData['department'];
      companyNameController.text = userData['company_name'];
      headlineController.text = userData['headline'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return commonStructure(
        context: context,
        padding: 0,
        appBar: commonAppBar(title: 'Edit Your Card', actionWidgets: [
          IconButton(
              onPressed: () async {
                if (widget.isFromEdit) {
                  var ref = FirebaseFirestore.instance.doc('users/${kAuthenticationController.userId}');

                  ref.update({
                    'first_name': firstNameController.text,
                    'last_name': lastNameController.text,
                    'jon_title': jobTitleController.text,
                    'department': departmentNameController.text,
                    'company_name': companyNameController.text,
                    'headline': headlineController.text,
                    'fields': kHomeController.addFieldsModelList
                  }).whenComplete(() async {
                    showLog('Data added successfully...');
                  });

                  if (isProfileChanged.value) {
                    await uploadFile(
                        filePath: kAuthenticationController.selectedImage.value, isProfile: true, callBack: () {});
                  }
                  if (isLogoChanged.value) {
                    await uploadFile(
                        filePath: kAuthenticationController.selectedCompanyLogo.value,
                        isProfile: false,
                        callBack: () {});
                  }
                  Get.back();
                } else {
                  addNewCard(() {
                    Get.back();
                  });
                }
              },
              icon: Icon(
                Icons.done,
                color: colorPrimary,
              ))
        ]),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Obx(
              () => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.heightBox,
                        SizedBox(
                          height: getScreenHeight(context) * 0.28,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: getScreenHeight(context) * 0.22,
                                      width: getScreenWidth(context) * 0.9,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
                                        BoxShadow(
                                            color: colorGrey.withOpacity(0.5),
                                            offset: const Offset(0.0, 3.0),
                                            blurRadius: 10)
                                      ]),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image(
                                          fit: BoxFit.cover,
                                          image: kAuthenticationController.selectedCompanyLogo.value.isNotEmpty
                                              ? FileImage(File(kAuthenticationController.selectedCompanyLogo.value))
                                                  as ImageProvider
                                              : bgPlaceholder,
                                        ),
                                        // backgroundImage: userProfile2,
                                      ),
                                    ),
                                    Container(
                                      height: getScreenHeight(context) * 0.22,
                                      width: getScreenWidth(context) * 0.9,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15), color: colorBlack.withOpacity(0.15)),
                                      child: Center(
                                          child: commonButtonView(
                                              title: 'Upload Company Logo',
                                              tapOnButton: () {
                                                picImageFromGallery(
                                                    isProfile: false,
                                                    callBack: () {
                                                      isLogoChanged.value = true;
                                                    });
                                              },
                                              height: 45,
                                              textStyle: FontStyleUtility.greyInter14W400,
                                              width: getScreenWidth(context) * 0.5)),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      margin: const EdgeInsets.only(right: 30),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          boxShadow: const [
                                            BoxShadow(color: colorGrey, offset: Offset(0.0, 3.0), blurRadius: 10)
                                          ]),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: Image(
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          image: kAuthenticationController.selectedImage.value.isNotEmpty
                                              ? FileImage(File(kAuthenticationController.selectedImage.value))
                                                  as ImageProvider
                                              : profilePlaceholder,
                                        ),
                                        // backgroundImage: userProfile2,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        picImageFromGallery(
                                            isProfile: true,
                                            callBack: () {
                                              isProfileChanged.value = true;
                                            });
                                      },
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        margin: const EdgeInsets.only(right: 30),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: colorBlack.withOpacity(0.15)),
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: colorWhite,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        20.heightBox,
                        commonTextField(
                            hintText: 'Enter your first name',
                            textEditingController: firstNameController,
                            validationFunction: (value) {
                              emptyFieldValidation(value);
                            }),
                        commonTextField(
                            hintText: 'Enter your last name',
                            textEditingController: lastNameController,
                            validationFunction: (value) {
                              emptyFieldValidation(value);
                            }),
                        commonTextField(
                            hintText: 'Enter your job title',
                            textEditingController: jobTitleController,
                            validationFunction: (value) {
                              emptyFieldValidation(value);
                            }),
                        commonTextField(
                            hintText: 'Enter your department name',
                            textEditingController: departmentNameController,
                            validationFunction: (value) {
                              emptyFieldValidation(value);
                            }),
                        commonTextField(
                            hintText: 'Enter your company name',
                            textEditingController: companyNameController,
                            validationFunction: (value) {
                              emptyFieldValidation(value);
                            }),
                        commonTextField(hintText: 'Enter your headline', textEditingController: headlineController),
                        20.heightBox,
                        commonSwitchRow(enable: branding, title: 'Display $appName branding on card'),
                        commonSwitchRow(enable: logoToQr, title: 'Add Logo to Qe Code'),
                        commonSwitchRow(enable: metField, title: '\'Where We Met\' field'),
                        kHomeController.addFieldsModelList.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                        decoration: BoxDecoration(
                                            color: colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(5)),
                                        child: Text(
                                          'Tap a field below to add it +',
                                          style: FontStyleUtility.blackInter16W500,
                                        ),
                                      ),
                                    ),
                                    20.heightBox,
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemCount: kHomeController.addFieldsModelList.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: Container(
                                            height: 50,
                                            width: 50,
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                                color: colorPrimary, borderRadius: BorderRadius.circular(100)),
                                            child: Image(
                                              image: kHomeController.socialMediaList[index].logo,
                                              color: colorWhite,
                                            ),
                                          ),
                                          title: Text(
                                            kHomeController.addFieldsModelList[index]['data'],
                                            style: FontStyleUtility.blackInter16W500,
                                          ),
                                          subtitle: Text(
                                            kHomeController.addFieldsModelList[index]['label'],
                                            style: FontStyleUtility.greyInter14W400,
                                          ),
                                          trailing: IconButton(
                                              onPressed: () {
                                                showAlertDialog(
                                                    title: 'Delete?',
                                                    msg:
                                                        'Are you sure you want to delete this field from social profile list?',
                                                    context: context,
                                                    callback: () {
                                                      kHomeController.addFieldsModelList
                                                          .remove(kHomeController.addFieldsModelList[index]);
                                                    });
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: colorGrey,
                                                size: 22,
                                              )),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              )
                            : SizedBox.shrink(),
                        20.heightBox,
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                color: colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              'Tap a field below to add it +',
                              style: FontStyleUtility.blackInter16W500,
                            ),
                          ),
                        ),
                        20.heightBox,
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        color: colorPrimary.withOpacity(0.15),
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: kHomeController.socialMediaList.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.2),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            highlightColor: colorWhite,
                            splashColor: colorWhite,
                            onTap: () {
                              Get.to(() => AddFieldScreen(index: index));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  padding: EdgeInsets.all(15),
                                  decoration:
                                      BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(100)),
                                  child: Image(
                                    image: kHomeController.socialMediaList[index].logo,
                                    color: colorWhite,
                                  ),
                                ),
                                Text(
                                  kHomeController.socialMediaList[index].name,
                                  style: FontStyleUtility.blackInter14W500.copyWith(color: colorPrimary),
                                )
                              ],
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  void addNewCard(Function callBack) async {
    if (formKey.currentState!.validate()) {
      try {
        var ref = FirebaseFirestore.instance.collection('users');

        ref.add({
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'jon_title': jobTitleController.text,
          'department': departmentNameController.text,
          'company_name': companyNameController.text,
          'headline': headlineController.text,
          'company_logo': '',
          'profile_pic': '',
          'fields': {'data': 'data1....', 'label': 'label1', 'title': 'title1'}
        }).whenComplete(() async {
          showLog('====== ${ref.id}');
          showLog('====== ${ref.doc().id}');
          showLog('Data added successfully...');
        });

        if (isProfileChanged.value) {
          await uploadFile(
              filePath: kAuthenticationController.selectedImage.value,
              isProfile: true,
              callBack: () async {
                await ref.doc().update({'profile_pic': profilePicUrl});
              });
        }
        if (isLogoChanged.value) {
          await uploadFile(
              filePath: kAuthenticationController.selectedCompanyLogo.value,
              isProfile: false,
              callBack: () async {
                await ref.doc().update({'company_logo': profilePicUrl});
              });
        }
        callBack();
      } catch (e) {
        showLog(e);
      }
    }
  }
}

Widget commonSwitchRow({required String title, required RxBool enable}) {
  return Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: FontStyleUtility.blackInter22W400.copyWith(fontSize: 20),
        ),
      ),
      Switch(
          value: enable.value,
          onChanged: (val) {
            enable.value = val;
          }),
    ],
  );
}
