import 'package:get/get.dart';

import '../App/Authentication/Controller/authentication_controller.dart';
// import 'package:blinq/Controller/AuthenticationController.dart';
// import 'package:blinq/Controller/InboxController.dart';
// import 'package:blinq/Controller/home_controller.dart';
// import 'package:blinq/Controller/my_stocks_controller.dart';
// import 'package:blinq/Controller/profile_controller.dart';

AuthenticationController kAuthenticationController = Get.put(AuthenticationController());

class PrefConstants {
  static const String userPreference = "UserPreference";
  static const String isLogin = "isLogin";
  static const String rememberMe = "rememberMe";
  static const String showOnBoarding = "showOnBoarding";
  static const String loginToken = "loginToken";
  static const String email = "email";
  static const String password = "password";
  static const String userDetails = "userDetails";
  static const String userFlags = "userFlags";
  static const String id = "id";

  static const String socialProfileGoogle = "socialProfileGoogle";
  static const String socialProfileFacebook = "socialProfileFacebook";
  static const String socialProfileInta = "socialProfileInta";
  static const String socialProfileGettr = "socialProfileGettr";
  static const String socialProfileYoutube = "socialProfileYoutube";
  static const String socialProfileRumble = "socialProfileRumble";
  static const String socialProfileTelegram = "socialProfileTelegram";
}
