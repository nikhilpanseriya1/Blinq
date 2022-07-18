import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  RxString selectedImage = ''.obs;
  RxString selectedCompanyLogo = ''.obs;

  final userAuthentication = FirebaseAuth.instance;

  /// Firebase useId
  String userId = '';
}
