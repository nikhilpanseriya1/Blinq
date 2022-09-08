import 'dart:io';

import 'package:blinq/Utility/constants.dart';
import 'package:blinq/Utility/utility_export.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Home/home_screen.dart';
import 'login_screen.dart';

class StepperScreen extends StatefulWidget {
  const StepperScreen({Key? key}) : super(key: key);

  @override
  State<StepperScreen> createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {


  RxList<Map<String, dynamic>> addMyField = <Map<String, dynamic>>[].obs;

  RxInt selectedStep = 0.obs;
  PageController pageController = PageController();
  String profilePic = '';
  String companyLogo = '';
  String selectedCountryCode = '+91';

  RxBool isShowLocation = false.obs;
  RxBool isProfileChanged = false.obs;
  RxBool isLogoChanged = false.obs;
  RxBool isLoading = false.obs;

  // final auth = FirebaseAuth.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController departmentNameController = TextEditingController();
  TextEditingController companyWebsiteController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     kHomeController.addFieldsModelList.clear();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: commonStructure(
        context: context,
        appBar: commonAppBar(backButtonCallBack: () {
          if (selectedStep.value > 0) {
            if (selectedStep.value == 1) {
              return;
            }
            pageController.animateToPage(--selectedStep.value, duration: const Duration(milliseconds: 400), curve: Curves.bounceInOut);
          } else {
            Get.back();
          }
        }),
        child: Form(
          key: formKey,
          child: SizedBox(
            height: getScreenHeight(context),
            width: getScreenWidth(context),
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: getScreenHeight(context) * 0.05,
                    child: StepProgressIndicator(
                      totalSteps: 7,
                      currentStep: selectedStep.value + 1,
                      selectedColor: colorRed,
                      unselectedColor: colorGrey,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: SizedBox(
                        height: getScreenHeight(context) * 0.9,
                        child: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          onPageChanged: (index) {
                            selectedStep.value = index;
                          },
                          controller: pageController,
                          children: [
                            step1(),
                            step2(),
                            step3(),
                            step4(),
                            step5(),
                            step6(),
                            // step7(),
                            // step8(),
                            step9(),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingButton: Obx(
          () => Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 10),
            child: isLoading.value
                ? CircularProgressIndicator()
                : FloatingActionButton(
                    onPressed: () async {
                      ///
                      if (formKey.currentState!.validate()) {
                        disableFocusScopeNode(context);

                        if (selectedStep.value == 0) {
                          kAuthenticationController.userAuthentication
                              .createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text)
                              .then((value) {
                            // Get.offAll(() => const HomeScreen());
                            /// save userId
                            setObject(PrefConstants.userId, value.user?.uid);
                            pageController.animateToPage(++selectedStep.value,
                                duration: const Duration(milliseconds: 400), curve: Curves.bounceInOut);
                          }).catchError((e) {
                            showLog(e.message);
                            showBottomSnackBar(context: context, message: e.message);
                            // showSnackBar(message: e.message);
                          });
                        } else if (selectedStep.value == 4) {
                          if (isProfileChanged.value) {
                            isLoading.value = true;
                            profilePic = await uploadFile(
                              filePath: kAuthenticationController.selectedImage.value,
                              isProfile: true,
                            );
                            pageController.animateToPage(++selectedStep.value,
                                duration: const Duration(milliseconds: 400), curve: Curves.bounceInOut);
                            isLoading.value = false;
                          }
                        } else if (selectedStep.value == 5) {
                          if (isLogoChanged.value) {
                            isLoading.value = true;
                            companyLogo = await uploadFile(
                              filePath: kAuthenticationController.selectedCompanyLogo.value,
                              isProfile: false,
                            );
                            pageController.animateToPage(++selectedStep.value,
                                duration: const Duration(milliseconds: 400), curve: Curves.bounceInOut);
                            isLoading.value = false;
                          }
                        } else if (selectedStep.value == 6) {
                          addNewCard(() {
                            kAuthenticationController.userId = getObject(PrefConstants.userId);
                            Get.offAll(() => const HomeScreen());
                          });
                        } else {
                          pageController.animateToPage(++selectedStep.value, duration: const Duration(milliseconds: 400), curve: Curves.bounceInOut);
                        }
                      }
                    },
                    // jevin.gondaliya@gmail.com
                    backgroundColor: colorPrimary,
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: colorWhite,
                    ),
                  ),
          ),
        ),
        bottomNavigation: Obx(
          () => SizedBox(
            child: selectedStep.value == 0
                ? InkWell(
                    highlightColor: colorWhite,
                    splashColor: colorWhite,
                    onTap: () {
                      Get.off(() => const LoginScreen());
                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        'LOG IN WITH EXISTING ACCOUNT',
                        style: FontStyleUtility.blackInter18W500.copyWith(color: colorPrimary),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  void addNewCard(Function callBack) async {
    try {
      List<String> cards = [];
      var ref = FirebaseFirestore.instance.collection('users');

      String newCardId = getObject(PrefConstants.userId);

      cards.add(newCardId);

      addMyField.add({'data': emailController.text, 'label': 'Email', 'title': 'Email'}); // add Email
      addMyField
          .add({'data': '$selectedCountryCode ${phoneController.text.trim()}', 'label': 'Call', 'title': 'Phone Number'}); // add Phone Number
      addMyField
          .add({'data': companyWebsiteController.text, 'label': 'Visit our website', 'title': 'Company Website'}); // add Website

      ref.doc(newCardId).set({
        'first_name': nameController.text,
        'last_name': lastNameController.text,
        'contact_number': phoneController.text,
        'job_title': jobTitleController.text,
        'email': emailController.text,
        'department': departmentNameController.text,
        'company_name': companyNameController.text,
        'company_website': companyWebsiteController.text,
        'headline': '',
        'location': '',
        'company_logo': companyLogo,
        'profile_pic': profilePic,
        'contacts': [],
        'cards': cards,
        'fields': addMyField
      }).whenComplete(() {
        showLog('======= ${newCardId}');

        showLog('Data added successfully...');
        callBack();
      });
    } catch (e) {
      showLog(e);
      showLog('something went wrong...');
    }
  }

  Widget step1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.heightBox,
        Text(
          'Register your account',
          style: FontStyleUtility.blackInter26W300.copyWith(height: 1.5),
        ),
        commonTextField(
            hintText: 'Enter your first name',
            textEditingController: nameController,
            validationFunction: (val) {
              return emptyFieldValidation(val);
            }),
        commonTextField(
            hintText: 'Enter your last name',
            textEditingController: lastNameController,
            validationFunction: (val) {
              return emptyFieldValidation(val);
            }),
        commonTextField(
            hintText: 'Enter your email address',
            textEditingController: emailController,
            validationFunction: (String val) {
              return emptyFieldValidation(val.trim());
            }),
        commonTextField(
            hintText: 'Enter your password',
            textEditingController: passwordController,
            isPassword: true,
            errorMaxLines: 2,
            validationFunction: (val) {
              return passwordValidation(val);
            }),
      ],
    );
  }

  Widget step2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.heightBox,
        Text(
          'Add, your work contact information?',
          style: FontStyleUtility.blackInter26W300.copyWith(height: 1.5),
        ),
        commonTextField(
          hintText: 'Email address',
          isEnabled: false,
          textEditingController: emailController,
        ),
        commonTextField(
            preFixWidget: SizedBox(
              width: 110,
              child: commonCountryCodePicker(
                onChanged: (value) {
                  selectedCountryCode = value;
                },
                borderColor: colorWhite.withOpacity(0.0),
                initialSelection: 'IN',
                isShowDropIcon: false,
              ),
            ),
            hintText: 'Enter your phone number',
            keyboardType: TextInputType.number,
            textEditingController: phoneController,
            maxLength: 14,
            validationFunction: (val) {
              return phoneValidationFunction(val);
            }),
      ],
    );
  }

  Widget step3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.heightBox,
        Text(
          'What company information would you like to display?',
          style: FontStyleUtility.blackInter26W300.copyWith(height: 1.5),
        ),
        commonTextField(
            hintText: 'Enter your company name',
            textEditingController: companyNameController,
            validationFunction: (val) {
              return emptyFieldValidation(val);
            }),
        commonTextField(
            hintText: 'Enter your job title',
            textEditingController: jobTitleController,
            validationFunction: (val) {
              return emptyFieldValidation(val);
            }),
        commonTextField(
            hintText: 'Enter your department name',
            textEditingController: departmentNameController,
            validationFunction: (val) {
              return emptyFieldValidation(val);
            }),
      ],
    );
  }

  Widget step4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.heightBox,
        Text(
          'What about your company website?',
          style: FontStyleUtility.blackInter26W300.copyWith(height: 1.5),
        ),
        commonTextField(
            hintText: 'Enter your company website',
            textEditingController: companyWebsiteController,
            validationFunction: (val) {
              return urlOrLinkValidation(val);
            }),
      ],
    );
  }

  Widget step5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.heightBox,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'Now, let\'s add your profile picture!',
            style: FontStyleUtility.blackInter26W300.copyWith(height: 1.5),
          ),
        ),
        Expanded(
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                75.heightBox,
                Container(
                  height: 125,
                  width: 125,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: const [BoxShadow(color: colorGrey, offset: Offset(0.0, 3.0), blurRadius: 10)]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image(
                      height: 125,
                      width: 125,
                      fit: BoxFit.cover,
                      image: kAuthenticationController.selectedImage.value.isNotEmpty
                          ? FileImage(File(kAuthenticationController.selectedImage.value)) as ImageProvider
                          : profilePlaceholder,
                    ),
                    // backgroundImage: userProfile2,
                  ),
                ),
                30.heightBox,
                Center(
                  child: commonFillButtonView(
                      title: kAuthenticationController.selectedImage.value.isNotEmpty ? '-  Remove Profile Picture' : '+  Add Profile Picture',
                      tapOnButton: () {
                        kAuthenticationController.selectedImage.value.isNotEmpty
                            ? kAuthenticationController.selectedImage.value = ''
                            : picImageFromGallery(
                                isProfile: true,
                                callBack: () {
                                  isProfileChanged.value = true;
                                });
                      },
                      width: getScreenWidth(context) * 0.6),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget step6() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.heightBox,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            'Now let\'s set up your company logo!',
            style: FontStyleUtility.blackInter26W300.copyWith(height: 1.5),
          ),
        ),
        Expanded(
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                75.heightBox,
                Container(
                  height: 200,
                  width: getScreenWidth(context) * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [BoxShadow(color: colorGrey.withOpacity(0.5), offset: const Offset(0.0, 3.0), blurRadius: 10)]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image(
                      fit: BoxFit.cover,
                      image: kAuthenticationController.selectedCompanyLogo.value.isNotEmpty
                          ? FileImage(File(kAuthenticationController.selectedCompanyLogo.value)) as ImageProvider
                          : bgPlaceholder,
                    ),
                    // backgroundImage: userProfile2,
                  ),
                ),
                30.heightBox,
                Center(
                  child: commonFillButtonView(
                      title: kAuthenticationController.selectedCompanyLogo.value.isNotEmpty ? '+  Replace Logo' : '+  Add Logo',
                      tapOnButton: () {
                        picImageFromGallery(
                            isProfile: false,
                            callBack: () {
                              isLogoChanged.value = true;
                            });
                      },
                      width: getScreenWidth(context) * 0.6),
                ),
                kAuthenticationController.selectedCompanyLogo.value.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: TextButton(
                            onPressed: () {
                              kAuthenticationController.selectedCompanyLogo.value = '';
                            },
                            child: Text(
                              'Remove Logo',
                              style: FontStyleUtility.blackInter18W600.copyWith(color: colorRed),
                            )),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget step7() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.heightBox,
          Text(
            'Let\'s add the \'Where we met\' field to your $appName card!',
            style: FontStyleUtility.blackInter26W300.copyWith(height: 1.5),
          ),
          30.heightBox,
          Text(
            'Add a personal touch to your business card by letting others remembers where they met you.',
            style: FontStyleUtility.blackInter26W300.copyWith(height: 1.5),
          ),
          40.heightBox,
          Center(
            child: Obx(
              () => CupertinoSwitch(
                  trackColor: colorGrey.withOpacity(0.5),
                  activeColor: colorPrimary,
                  value: isShowLocation.value,
                  onChanged: (value) {
                    isShowLocation.value = value;
                  }),
            ),
          ),
          20.heightBox,
        ],
      ),
    );
  }

  Widget step8() {
    return InkWell(
      splashColor: colorWhite,
      highlightColor: colorWhite,
      onTap: () {
        disableFocusScopeNode(context);
      },
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            20.heightBox,
            Text(
              'Enter your login details',
              style: FontStyleUtility.blackInter26W300.copyWith(height: 1.5),
            ),
            30.heightBox,
            commonTextField(hintText: 'Enter your login email', textEditingController: null),
            commonTextField(hintText: 'Enter your password', textEditingController: null, isPassword: true),
            commonTextField(hintText: 'Confirm password', textEditingController: null, isPassword: true),
            20.heightBox,
          ],
        ),
      ),
    );
  }

  Widget step9() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        20.heightBox,
        Text(
          'Great job, you\'ve created your $appName business card!',
          style: FontStyleUtility.blackInter26W300.copyWith(height: 1.5),
        ),
        30.heightBox,
        Text(
          'Now let\'s add the $appName widget so you can quickly share it with people you meet!',
          style: FontStyleUtility.blackInter26W300.copyWith(height: 1.5),
        ),
      ],
    );
  }

  Future<void> checkUserValid() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text);
    } catch (e) {
      showLog(e);
    }
  }
}

Future<void> picImageFromGallery({required bool isProfile, Function? callBack}) async {
  var permissionStatus = await Permission.storage.status;
  if (!permissionStatus.isGranted) await Permission.storage.request();
  if (await Permission.storage.isGranted) {
    // Pick an image
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        File imageTemporary = File(image.path);

        // final bytes = imageTemporary.readAsBytesSync().lengthInBytes;
        // final kb = bytes / 1024;
        // final mb = kb / 1024;
        //
        // showLog('==== $kb');
        // showLog('==== $mb');
        //
        // String tempDir = (await getTemporaryDirectory()).path;
        //
        // File tempFile = File(tempDir);
        //
        // var result = await FlutterImageCompress.compressWithFile(
        //   imageTemporary.absolute.path,
        //   minWidth: 720,
        //   minHeight: 380,
        //   quality: 94,
        //   rotate: 90,
        // );
        //
        // // 2. compress file and get file.
        // // var result = await FlutterImageCompress.compressAndGetFile(
        // //   imageTemporary.absolute.path,
        // //   tempDir.path,
        // //   quality: 88,
        // //   rotate: 180,
        // // );
        // //
        // print('---- ${imageTemporary.lengthSync()}');
        // print('---- ${result?.length}');
        //
        // tempFile.writeAsBytesSync(result!);
        //
        // final bytess = imageTemporary.readAsBytesSync().lengthInBytes;
        // final kbb = bytess / 1024;
        // final mbb = kbb / 1024;
        //
        // showLog('==== New $kbb');
        // showLog('==== New $mbb');

        // child: Image.memory(headedBitmap)

        isProfile
            ? kAuthenticationController.selectedImage.value = imageTemporary.path
            : kAuthenticationController.selectedCompanyLogo.value = imageTemporary.path;

        if (callBack != null) {
          callBack();
        }
      }
    } on PlatformException catch (e) {
      print('failed to pic image: $e');
    }
  } else {
    if (permissionStatus.isPermanentlyDenied) {
      print('====> Permanently denied');
      openAppSettings();
    }
    myToast(message: "Provide Storage permission to pic photos.");
  }
}
