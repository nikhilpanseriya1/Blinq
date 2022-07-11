import 'dart:convert';

import 'package:blinq/Utility/utility_export.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:validators/validators.dart';

import '../main.dart';
import 'constants.dart';

// import 'package:lt_stock/API/api_config.dart';
// import 'package:lt_stock/Controller/AuthenticationController.dart';
// import 'package:lt_stock/Model/AuthenticationModule/LoginModel.dart';
// import 'package:lt_stock/Utility/constants.dart';
// import 'package:lt_stock/Utility/utility_export.dart';
//
// import '../Model/AuthenticationModule/AddUserDetailModel.dart';

// emailValidationFunction(String val) {
//   if (val.isNotEmpty) {
//     return GetUtils.isEmail(val) ? null : loginEmailError;
//   } else {
//     return "Please enter email address";
//   }
// }

showSnackBar({String title = appName, required String message, Color? color, Color? textColor, int? duration}) {
  return Get.snackbar(
    title, // title
    message, // message
    backgroundColor: color ?? Colors.green,
    colorText: textColor ?? Colors.white,
    icon: Icon(
      Icons.error,
      color: textColor ?? Colors.white,
    ),
    onTap: (_) {},
    shouldIconPulse: true,
    barBlur: 10,
    isDismissible: true,
    duration: Duration(seconds: duration ?? 2),
  );
}

showBottomSnackBar({
  required BuildContext context,
  required String message,
  /*Color? color, Color? textColor, int? duration*/
}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: colorPrimary,
  ));
}

void showInSnackBar({String? text, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text ?? ""), duration: const Duration(seconds: 2)));
}

/// Authentication Function

getObject(String key) {
  return getPreference.read(key) != null ? json.decode(getPreference.read(key)) : null;
}

setObject(String key, value) {
  getPreference.write(key, json.encode(value));
}

getSocialProfile(String key) {
  return getPreference.read(key);
}

setSocialProfile(String key, value) {
  getPreference.write(key, value);
}

// Rx<LoginModelDataUserDetails> loginUserData = LoginModelDataUserDetails().obs;

// getLoginUserData() {
//   if (json.decode(getPreference.read(PrefConstants.loginPref)) != null) {
//     // kAuthenticationController.loginModel.value = LoginModel.fromJson(getObject(ApiConfig.loginPref));
//     kAuthenticationController.loginModel.value = LoginModel.fromJson(
//         json.decode(getPreference.read(ApiConfig.loginPref)));
//     // loginUserData.value = loginResponse;
//     return kAuthenticationController.loginModel.value;
//   } else {
//     return null;
//   }
// }

// AddUserDetailModel? getUserData() {
//   if (getObject(ApiConfig.userDetails) != null) {
//     AddUserDetailModel userResponse =
//         AddUserDetailModel.fromJson(getObject(ApiConfig.loginPref));
//     kAuthenticationController.addUserDetailModel.value = userResponse;
//     return userResponse;
//   } else {
//     return null;
//   }
// }

creditCardValidationFunction(String val) {
  if (val.isNotEmpty) {
    // return CreditCardNumberInputFormatter();
    return val.length == 19 ? null : creditCardError;
  } else {
    return 'please enter card number';
  }
}

// passValidationFunction(String val) {
//   if (val.isNotEmpty) {
//     return val.length > 6 ? null : passwordError;
//   } else {
//     return "Please enter password";
//   }
// }

checkMailOrPhone(String val) {
  if (val.isNotEmpty) {
    String pattern = r'(^(?:[+0]9)?[0-9]{9,16}$)';
    RegExp regExp = RegExp(pattern);
    String mail = val;
    return regExp.hasMatch(mail);
  }
}

phoneValidationFunction(String val) {
  if (val.isNotEmpty) {
    return GetUtils.isPhoneNumber(val) ? null : phoneNumberError;
  } else {
    return "Please enter phone number";
  }
}

// setFcmToken(String value) {
//   getPreference.write(ApiConfig.fcmTokenPref, value);
// }

// Api Functions

RegExp passwordRegExpValid =
    RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%#^()*?-_&])[A-Za-z\d@$!%*-_?&#^()]{8,}$");

isNotEmptyString(String? data) {
  return data != null && data.isNotEmpty;
}

// getFcmToken() {
//   return getPreference.read(ApiConfig.fcmTokenPref) ?? "";
// }

hideKeyBoard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

// setFcmToken(String value) {
//   getPreference.write(AppTexts.fcmTokenPref, value);
// }

showLog(text) {
  debugPrintThrottled(text ?? "", wrapWidth: 2256);
}

setIsLogin({required bool isLogin}) {
  return getPreference.write(PrefConstants.isLogin, isLogin);
}

bool getIsLogin() {
  return (getPreference.read(PrefConstants.isLogin) ?? false);
}

String getLoginToken() {
  return (getPreference.read(PrefConstants.loginToken));
}

dateFormatter(String? dateTime, {String? myFormat}) {
  final DateTime now = DateTime.now();

  /// Your date format
  final DateFormat formatter = DateFormat(myFormat ?? 'MM/dd/yyyy');
  final String formatted;
  if (isNotEmptyString(dateTime)) {
    // 'yyyy-MM-dd'
    formatted = formatter.format(DateFormat('yyyy-MM-dd').parse(dateTime!));
  } else {
    formatted = 'please enter date';
    // formatted = formatter.format(now);
  }
  return formatted;
}

// bool getIsLogin() {
//   return (getPreference.read(ApiConfig.isLoginPref) ?? false);
// }
//
// setIsLogin({required bool isLogin}) {
//   getPreference.write(ApiConfig.isLoginPref, isLogin);
// }
//
// setStringPrefrences(String key, value) {
//   getPreference.write(key, value);
// }
//
// getStringPrefrences(String key) {
//   return getPreference.read(key);
// }

emptyFieldValidation(value, {String? msg}) {
  return value.toString().isEmpty ? msg ?? notEmptyFieldMessage : null;
}

urlOrLinkValidation(value, {String? msg}) {
  if (!isURL(value)) {
    return msg ?? 'Please enter a valid URL';
  }
  return null;
}

alertPriceFieldValidation(value, String msg) {
  if (value.toString().isEmpty) {
    return msg;
  } else if (value.isNotEmpty) {
    // String pattern = '^\d{0,8}(\.\d{1,4})?\$';
    RegExp regExp = RegExp(r'\d{0,8}(\.\d{1,4})?+$');
    ;
    if (value.isEmpty || regExp.hasMatch(value)) {
      return 'Enter a valid price';
    }
  }
}

profileLinkValidation(String value) {
  return value.isEmpty
      ? 'Please enter profile link'
      : value.contains('http')
          ? null
          : 'Please enter valid profile link';
}

// emailValidation(String? value) {
//   if (value?.isEmpty ?? false) {
//     return 'Please enter email address.';
//   } else if (value?.isNotEmpty ?? false) {
//     String pattern = r"^[a-zA-Z0-9.]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//         r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z-]"
//         r"{0,253}[a-zA-Z])?)*$";
//     RegExp regex = RegExp(pattern);
//     if (value!.isEmpty || !regex.hasMatch(value)) {
//       return 'Enter a valid email address.';
//     }
//   }
// }

urlValidation(String? value) {
  if (value?.isEmpty ?? false) {
    return 'Please enter URL';
  } else if (value?.isNotEmpty ?? false) {
    GetUtils.isURL(value ?? '') ? null : 'Please enter valid URL';
  }
}

emailValidation(value) {
  return value.toString().isEmpty
      ? notEmptyFieldMessage
      : !GetUtils.isEmail(value)
          ? "Please Enter Valid Email Address"
          : null;
}

DateTime? exitBackPressTime;
DateTime? currentBackPressTime;

Future<bool> onWillPop() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(msg: 'press again to Exit!');
    return Future.value(false);
  }
  return Future.value(true);
}

// passwordValidation(String value) {
//   return value.toString().isEmpty
//       ? notEmptyFieldMessage
//       : value.length < 6
//           ? 'Enter At least 6 character'
//           : null;
// }

passwordValidation(String value) {
  return value.toString().isEmpty
      ? notEmptyFieldMessage
      : passwordRegExpValid.hasMatch(value)
          ? null
          : 'Password must be contain capital letter, small letter, special character and minimum 8 characters';
}

// launchURL(String url, {bool forceWeb = false}) async {
//   if (await canLaunch(url)) {
//     await launch(url, universalLinksOnly: forceWeb, forceWebView: forceWeb, forceSafariVC: forceWeb);
//   } else {
//     throw 'Could not launch $url';
//   }
// }

checkIsImage(String? urlThumbnail) {
  return isNotEmptyString(urlThumbnail) && isImage(urlThumbnail ?? "");
}

bool isImage(String filePath) {
  final ext = filePath.toLowerCase();

  return ext.endsWith(".jpg") ||
      ext.endsWith(".jpeg") ||
      ext.endsWith(".png") ||
      ext.endsWith(".svg") ||
      ext.endsWith(".gif") ||
      ext.endsWith(".bmp");
}
