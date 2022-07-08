import 'package:blinq/App/Home/Controller/home_controller.dart';
import 'package:get/get.dart';

import '../App/Authentication/Controller/authentication_controller.dart';

AuthenticationController kAuthenticationController = Get.put(AuthenticationController());
HomeController kHomeController = Get.put(HomeController());

class PrefConstants {
  static const String isLogin = "isLogin";
  static const String loginToken = "loginToken";
// static const String rememberMe = "rememberMe";
// static const String showOnBoarding = "showOnBoarding";
// static const String email = "email";
// static const String password = "password";
// static const String userDetails = "userDetails";
// static const String userFlags = "userFlags";
// static const String id = "id";
//
// static const String socialProfileGoogle = "socialProfileGoogle";
// static const String socialProfileFacebook = "socialProfileFacebook";
// static const String socialProfileInta = "socialProfileInta";
// static const String socialProfileGettr = "socialProfileGettr";
// static const String socialProfileYoutube = "socialProfileYoutube";
// static const String socialProfileRumble = "socialProfileRumble";
// static const String socialProfileTelegram = "socialProfileTelegram";
}
