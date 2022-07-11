import 'package:blinq/App/Home/home_screen.dart';
import 'package:blinq/Utility/constants.dart';
import 'package:blinq/Utility/utility_export.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return commonStructure(
        context: context,
        appBar: commonAppBar(),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.heightBox,
              Text(
                'Login to continue',
                style: FontStyleUtility.blackInter26W300.copyWith(height: 1.5),
              ),
              commonTextField(
                  hintText: 'Enter your email address',
                  textEditingController: emailController,
                  validationFunction: (String val) {
                    return emailValidation(val.trim());
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
          ),
        ),
        bottomNavigation: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 5),
          child: commonFillButtonView(
              title: 'Login',
              tapOnButton: () {
                if (formKey.currentState!.validate()) {
                  auth
                      .signInWithEmailAndPassword(email: emailController.text, password: passwordController.text)
                      .then((val) {
                    /// save userId
                    setObject(PrefConstants.userId, val.user?.uid);
                    Get.offAll(() => const HomeScreen());
                  }).catchError((e) {
                    showBottomSnackBar(context: context, message: e.message);
                  });
                }
              }),
        ));
  }
}
