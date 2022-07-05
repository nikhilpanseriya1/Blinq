import 'package:blinq/Utility/utility_export.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

// import 'package:lt_stock/Controller/home_flow_controller.dart';
// import 'package:lt_stock/Utility/utility_export.dart';
// import 'package:lt_stock/View/LoginFlow/login_view.dart';
// import 'package:lt_stock/View/MyStocksFlow/add_stock_view.dart';
// import 'package:video_player/video_player.dart';
//
// import '../View/HomeFlow/home_structure_view.dart';
// import '../View/LoginFlow/ForgotPassFlow/account_verify_view.dart';
// import '../View/LoginFlow/IntroQuestionsFlow/add_review_step7.dart';
// import '../View/LoginFlow/IntroQuestionsFlow/investing_goals_view_step2.dart';
// import '../View/LoginFlow/IntroQuestionsFlow/investing_horizon_view_step4.dart';
// import '../View/LoginFlow/IntroQuestionsFlow/like_to_invest_view_step5.dart';
// import '../View/LoginFlow/IntroQuestionsFlow/personal_detail_view_step1.dart';
// import '../View/LoginFlow/IntroQuestionsFlow/real_time_update_view_step3.dart';
// import '../View/LoginFlow/IntroQuestionsFlow/status_view_step6.dart';
import '../main.dart';
import 'common_function.dart';
import 'constants.dart';



Widget commonText(
    {required String text, required TextStyle style, TextAlign? textAlign}) {
  return Text(text, style: style, textAlign: textAlign ?? TextAlign.start);
}

disableFocusScopeNode(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

Widget commonRow(
    {required String title,
    required Widget suffix,
    TextStyle? titleTextStyle,
    TextStyle? textStyle,
    double? borderOpacity}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              child: commonText(
                  text: title,
                  style: titleTextStyle ?? FontStyleUtility.greyInter16W500)),
          suffix,
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 15),
        child: Divider(color: colorGrey.withOpacity(borderOpacity ?? 0.1)),
      ),
    ],
  );
}

Widget searchCommonRow(
    {required String title,
    required Widget suffix,
    TextStyle? titleTextStyle,
    TextStyle? textStyle,
    double? borderOpacity}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
              width: 100,
              child: commonText(
                  text: title,
                  style: titleTextStyle ?? FontStyleUtility.blackInter14W500)),
          suffix,
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 15),
        child: Divider(color: colorGrey.withOpacity(borderOpacity ?? 0.1)),
      ),
    ],
  );
}

Widget commonInboxCard(
    {required String text,
    required String timeText,
    Widget? suffixImage,
    Color? backgroundColor}) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 10),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colorDarkBlack.withOpacity(0.3),
          ),
          color: backgroundColor ?? colorOffWhite),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: commonText(
                          text: text,
                          style: FontStyleUtility.blackInter16W500
                              .copyWith(height: 1.4)),
                    ),
                    10.heightBox,
                    commonText(
                        text: timeText,
                        style: FontStyleUtility.greyInter16W500),
                  ],
                ),
              ),
            ),
            ClipRRect(
              child: suffixImage ?? const SizedBox(),
            )
          ],
        ),
      ),
    ),
  );
}

Widget introScreenCommonRow({required String text, bool? isSelected}) {
  return Container(
    height: 60,
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
        color: isSelected ?? false ? colorPrimary.withOpacity(0.1) : colorWhite,
        border: isSelected ?? false
            ? Border.all(color: colorPrimary)
            : Border.all(color: colorBlack.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(5)),
    child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: commonText(
          text: text,
          style: FontStyleUtility.greyInter14W500.copyWith(
              fontWeight:
                  isSelected ?? false ? FontWeight.w600 : FontWeight.w500)),
    ),
  );
}

getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

Widget loginFlowCommonBottomBar(
    {required Function() onTap,
    required String textSpanMessage,
    required String textSpanClick}) {
  return SizedBox(
    height: 40,
    child: Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Center(
        child: InkWell(
          highlightColor: colorWhite,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: textSpanMessage,
                    style: FontStyleUtility.blackInter16W500),
                TextSpan(
                    text: " $textSpanClick",
                    style: FontStyleUtility.blackInter16W500
                        .copyWith(color: colorPrimary))
              ]),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget commonProfileRow(
    {required Widget title,
    Widget? subTitle,
    required Function() onTap,
    int? height}) {
  return Column(
    children: [
      InkWell(
        onTap: () {},
        child: Container(
          color: colorWhite,
          child: ListTile(
            minLeadingWidth: 1,
            contentPadding: const EdgeInsets.only(
              left: 0.0,
            ),
            onTap: onTap,
            title: title,
            subtitle: subTitle == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: subTitle,
                  ),
            trailing: const Icon(
              Icons.arrow_forward_ios_sharp,
              color: colorSemiDarkBlack,
              size: 16,
            ),
          ),
        ),
      ),
      Divider(color: colorDarkBlack.withOpacity(0.3))
    ],
  );
}

Future<void> showAlertDialog(
    {required String title,
    required String msg,
    required BuildContext context,
    required Function() callback}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: FontStyleUtility.blackInter20W600),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(msg,
                  style:
                      FontStyleUtility.blackInter16W500.copyWith(height: 1.5)),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('No', style: FontStyleUtility.blackInter16W600),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: Text('Yes', style: FontStyleUtility.blackInter16W600),
            onPressed: () {
              callback();
              Get.back();
            },
          ),
        ],
      );
    },
  );
}

// BorderRadius commonButtonBorderRadius = BorderRadius.circular(5.0);
OutlineInputBorder countryBorder = OutlineInputBorder(
  borderSide:
      BorderSide(color: borderColor ?? colorBlack.withOpacity(0.1), width: 1),
  borderRadius: BorderRadius.circular(5.0),
);

commonCountryCodePicker({
  required Function onChanged,
  required String initialSelection,
  required TextEditingController textController,
  FocusNode? focusNode,
  bool? hideMainText,
  Color? borderColor,
  double? height,
  double? width,
  bool? alignLeft = false,
  bool isShowDropIcon = true,
}) {
  return Builder(builder: (context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      height: height ?? 60,
      decoration: BoxDecoration(
          border: Border.all(
              color: borderColor ?? colorBlack.withOpacity(0.1), width: 1),
          borderRadius: BorderRadius.circular(5.0)),
      child: Stack(
        children: [
          isShowDropIcon
              ? const Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                    size: 25,
                  ),
                )
              : const SizedBox(),
          CountryCodePicker(
            onInit: (code) {},
            flagWidth: 30,
            // hideMainText: true,
            padding: const EdgeInsets.all(0),
            onChanged: (cCode) {
              onChanged(cCode);
            },
            initialSelection: initialSelection,
            showCountryOnly: true,
            showOnlyCountryWhenClosed: true,
            searchStyle: FontStyleUtility.blackInter16W500,
            dialogTextStyle: FontStyleUtility.blackInter18W500,
            showFlagDialog: true,
            alignLeft: alignLeft ?? true,
            closeIcon: const Icon(
              Icons.close_sharp,
              size: 30,
              color: colorBlack,
            ),
            hideMainText: hideMainText ?? false,
            dialogBackgroundColor: Colors.black,
            showFlag: true,
            boxDecoration: BoxDecoration(
                color: colorWhite, borderRadius: BorderRadius.circular(20.0)),
            searchDecoration: InputDecoration(
              filled: true,
              // prefixIcon: const Icon(
              //   Icons.search,
              //   color: colorBlack,
              // ),
              fillColor: textFieldColor,
              contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              focusedBorder: countryBorder,
              disabledBorder: countryBorder,
              enabledBorder: countryBorder,
              errorBorder: countryBorder,
            ),
            textStyle: FontStyleUtility.blackInter16W500,
            dialogSize: Size(Get.width, Get.height - 60),
          ),
        ],
      ),
    );
  });
}

void myToast({required String message, Color? bgColor, Toast? toastLength}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength ?? Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: bgColor ?? Colors.grey,
      textColor: Colors.black,
      fontSize: 16.0);
}

// Widget commonDarkCard({required String title, required String description, required String timeText, ExactAssetImage? backgroundImage}) {
//   return Container(
//     height: 200,
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: colorGreen,
//         image: DecorationImage(image: backgroundImage ?? bannerImage1, fit: BoxFit.cover)),
//     child: Padding(
//       padding: const EdgeInsets.all(15),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           commonText(text: title, style: FontStyleUtility.blackInter18W500.copyWith(color: colorWhite)),
//           const SizedBox(height: 10),
//           commonText(text: description, style: FontStyleUtility.blackInter16W400.copyWith(color: colorWhite, height: 1.4)),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               commonText(text: 'Crypto news', style: FontStyleUtility.blackInter16W500.copyWith(color: colorWhite)),
//               commonText(text: timeText, style: FontStyleUtility.blackInter16W500.copyWith(color: colorWhite)),
//               const Spacer(),
//               Image(image: playRoundWhite, height: 40, width: 40, fit: BoxFit.cover)
//             ],
//           )
//         ],
//       ),
//     ),
//   );
// }

// Widget commonProfileAlertRow({required Widget title, required Function() onTap, int? height}) {
//   return Container(
//     decoration: BoxDecoration(
//       border: Border.all(color: colorBlack.withOpacity(0.1)),
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Expanded(child: title),
//               widthBox(width: 10),
//               Image(image: arrowDown),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Widget playVideo(
//     {required BuildContext context,
//     required VideoPlayerController videoController,
//     required RxBool isVideoPlay,
//     double? videoHeight,
//     double? videoWidth}) {
//   return Obx(
//     () => Stack(
//       children: [
//         SizedBox(
//           height: videoHeight ?? getScreenHeight(context),
//           width: videoWidth ?? getScreenWidth(context),
//           // child: Image(image: splashVideo, fit: BoxFit.cover),
//           child: videoController.value.isInitialized
//               ? Stack(
//                   children: [
//                     VideoPlayer(videoController),
//                   ],
//                 )
//               : Container(),
//         ),
//         SizedBox(
//           height: videoHeight ?? getScreenHeight(context),
//           width: videoWidth ?? getScreenWidth(context),
//           child: InkWell(
//             splashColor: colorWhite,
//             highlightColor: colorWhite,
//             onTap: () {
//               playPauseVideo(isVideoPlay: isVideoPlay, videoController: videoController);
//             },
//             // child: Image(image: videoPlayBtn),
//             child: isVideoPlay.value ? const SizedBox() : Image(image: videoPlayBtn),
//           ),
//         )
//       ],
//     ),
//   );
// }

// Widget commonDropdownButtonFormField({required String hint, required List<String> items, required int id, bool showHint = true}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Text(
//         //   title,
//         //   style: FontStyleUtility.blackInter14W500,
//         // ),
//         // heightBox(height: 10),
//         DropdownButtonFormField(
//             hint: showHint ? Text(hint, style: FontStyleUtility.greyInter16W500) : const SizedBox(),
//             icon: const Icon(
//               Icons.keyboard_arrow_down_outlined,
//               color: colorGrey,
//             ),
//             // value: selectedValue,
//             decoration: const InputDecoration(
//               border: UnderlineInputBorder(borderSide: BorderSide.none),
//             ),
//             // decoration: InputDecoration(
//             //   contentPadding: const EdgeInsets.all(12),
//             //   border: OutlineInputBorder(
//             //     borderSide: BorderSide(color: textColor.withOpacity(0.1)),
//             //     borderRadius: const BorderRadius.all(Radius.circular(12)),
//             //   ),
//             // ),
//             items: items.map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value, style: FontStyleUtility.blackInter16W500),
//               );
//             }).toList(),
//             onChanged: (value) {
//               // print("----->" + value.toString());
//               id == 0
//                   ? selectedTicker = value.toString()
//                   : id == 1
//                       ? selectedIndustry = value.toString()
//                       : selectedCompany = value.toString();
//             }),
//         Divider(color: colorGrey.withOpacity(0.5))
//         // heightBox(height: 15),
//       ],
//     ),
//   );
// }

// void playPauseVideo({required VideoPlayerController videoController, required RxBool isVideoPlay}) {
//   videoController.value.isPlaying ? videoController.pause() : videoController.play();
//   videoController.value.isPlaying ? isVideoPlay.value = true : isVideoPlay.value = false;
// }

// Widget simpleDropDownButton(
//     {required BuildContext context,
//     required RxString dropdownValue,
//     required List<String> options,
//     bool isBorder = false,
//     bool alignedDropdown = false}) {
//   return Container(
//     width: getScreenWidth(context),
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10), border: Border.all(color: isBorder ? colorBlack.withOpacity(0.1) : colorBlack.withOpacity(0))),
//     child: Obx(
//       () => DropdownButtonHideUnderline(
//         child: ButtonTheme(
//           alignedDropdown: alignedDropdown,
//           child: DropdownButton<String>(
//             value: dropdownValue.value,
//             borderRadius: const BorderRadius.all(Radius.circular(10)),
//             icon: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Image(image: downArrow),
//             ),
//             elevation: 3,
//             style: const TextStyle(color: textColor),
//             onChanged: (String? newValue) {
//               disableFocusScopeNode(context);
//               dropdownValue.value = newValue!;
//             },
//             items: options.map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     ),
//   );
// }

/*
Future commonDatePicker({required BuildContext context, required RxBool finalSelectedDate}) {
  return showDialog(
    context: context,
    builder: (BuildContext contextTwo) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 15,
        child: SizedBox(
          height: 325,
          width: 300,
          child: Column(
            children: [
              SizedBox(
                height: 250,
                width: 250,
                child: SfDateRangePicker(
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.single,
                  initialSelectedRange:
                      PickerDateRange(DateTime.now().subtract(const Duration(days: 4)), DateTime.now().add(const Duration(days: 3))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: commonFillButtonView(
                    title: 'Select',
                    tapOnButton: () {
                      finalSelectedDate.value = true;
                      Get.back(result: selectedDate.value);
                    }),
              )
            ],
          ),
        ),
      );
    },
  );
}

void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  if (args.value is DateTime) {
    selectedDate.value = args.value.toString();
  }
}*/

// void continueWithVerification({String? message, required BuildContext context}) {
//   if (kAuthenticationController.userModel.value.user != null) {
//     print("Status code ${kAuthenticationController.userModel.value.user?.status}");
//
//     if (kAuthenticationController.userModel.value.user?.status == 1) {
//       // Status Code 1 = Is User Verified
//       if (kAuthenticationController.userIntroFlagModel.value.goalOfInvestement != 1) {
//         if (kAuthenticationController.userIntroFlagModel.value.profile == 0) {
//           ///change this condition after change done in api
//           Get.to(() => const PersonalDetailViewStep1());
//         } else if (kAuthenticationController.userIntroFlagModel.value.investingGoal_1 == 0) {
//           Get.to(() => const InvestingGoalsViewStep2());
//         } else if (kAuthenticationController.userIntroFlagModel.value.updateConsent == 0) {
//           Get.to(() => const RealtimeUpdateViewStep3());
//         } else if (kAuthenticationController.userIntroFlagModel.value.investingExperience == 0) {
//           Get.to(() => const InvestingHorizonViewStep4());
//         } else if (kAuthenticationController.userIntroFlagModel.value.industryChoice == 0) {
//           Get.to(() => const LikeToInvestViewStep5());
//         } else if (kAuthenticationController.userIntroFlagModel.value.employementStatus == 0) {
//           Get.to(() => const StatueViewStep6());
//         } else if (kAuthenticationController.userIntroFlagModel.value.goalOfInvestement == 0) {
//           Get.to(() => const AddReviewStep7());
//         }
//       } else {
//         setObject(PrefConstants.userDetails, kAuthenticationController.userModel.value);
//         setObject(PrefConstants.userFlags, kAuthenticationController.userIntroFlagModel.value);
//         // setIsLogin(isLogin: true);
//         // showSnackBar(message: message);
//         Get.offAll(() => const HomeStructureView());
//       }
//     } else if (kAuthenticationController.userModel.value.user?.status == 0) {
//       // Status Code 0 = User Not Verified
//       Get.offAll(() => AccountVerifyView(
//             email: kAuthenticationController.userModel.value.user?.email ?? '',
//             contactNum: kAuthenticationController.userModel.value.user?.contactNo ?? '',
//           ));
//     } else if (kAuthenticationController.userModel.value.user?.status == 2) {
//       // Status Code 2 = User Blocked by Admin
//       showInSnackBar(context: context, text: blockByAdmin);
//     } else {
//       showSnackBar(message: 'Something went wrong, Please Login again');
//       Get.offAll(() => const LoginView());
//     }
//     // Get.offAll(() => const CreateFundRaiser());
//   }
// }
