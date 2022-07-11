import 'dart:io';

import 'package:blinq/App/Home/add_field_screen.dart';
import 'package:blinq/Utility/constants.dart';
import 'package:blinq/Utility/utility_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Authentication/stepper_screen.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  RxBool branding = true.obs;
  RxBool logoToQr = false.obs;
  RxBool metField = false.obs;

  @override
  Widget build(BuildContext context) {
    return commonStructure(
        context: context,
        padding: 0,
        appBar: commonAppBar(
            leadingIcon: IconButton(
                onPressed: () {
                  showLog('Click done...');
                  Get.back();
                },
                icon: Icon(
                  Icons.done,
                  color: colorPrimary,
                )),
            title: 'Edit Your Card',
            actionWidgets: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_horiz,
                    color: colorPrimary,
                  ))
            ]),
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
                                              picImageFromGallery(isProfile: false);
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
                                      picImageFromGallery(isProfile: true);
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
                      commonTextField(hintText: 'Enter your name', textEditingController: null),
                      commonTextField(hintText: 'Enter your job title', textEditingController: null),
                      commonTextField(hintText: 'Enter your department name', textEditingController: null),
                      commonTextField(hintText: 'Enter your company name', textEditingController: null),
                      commonTextField(hintText: 'Enter your headline', textEditingController: null),
                      20.heightBox,
                      commonSwitchRow(enable: branding, title: 'Display $appName branding on card'),
                      commonSwitchRow(enable: logoToQr, title: 'Add Logo to Qe Code'),
                      commonSwitchRow(enable: metField, title: '\'Where We Met\' field'),
                      20.heightBox,
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration:
                              BoxDecoration(color: colorGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(5)),
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.2),
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
        ));
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
