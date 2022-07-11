import 'package:blinq/App/Authentication/login_screen.dart';
import 'package:blinq/App/Authentication/stepper_screen.dart';
import 'package:blinq/Utility/utility_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return commonStructure(
        context: context,
        bgColor: colorRed,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              75.heightBox,
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: colorWhite),
                      padding: const EdgeInsets.all(2),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                            image: appIcon,
                            height: 125,
                            width: 125,
                            fit: BoxFit.cover,
                          )),
                    ),
                    10.heightBox,
                    Text(
                      'Welcome to $appName',
                      style: FontStyleUtility.blackDMSerifDisplay20W400.copyWith(color: colorWhite, fontSize: 22),
                    ),
                    50.heightBox,
                    Text(
                      'Let\'s get your new $appName\nbusiness card set up',
                      style: FontStyleUtility.blackInter26W400.copyWith(color: colorWhite, height: 1.3),
                      textAlign: TextAlign.center,
                    ),
                    50.heightBox,
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Get.to(() => const StepperScreen());
                      },
                      child: Container(
                        height: 100,
                        width: getScreenWidth(context) * 0.8,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: colorWhite),
                        child: Center(
                            child: Text(
                          'GET STARTED',
                          style: FontStyleUtility.blackInter20W600.copyWith(color: colorRed),
                        )),
                      ),
                    ),
                    50.heightBox,
                    TextButton(
                      onPressed: () {
                        Get.to(() => const LoginScreen());
                      },
                      child: Text(
                        'LOG IN WITH EXISTING ACCOUNT',
                        style: FontStyleUtility.blackInter20W600.copyWith(color: colorWhite),
                      ),
                    ),
                    50.heightBox,
                    Text(
                      'ENTER A BLINQ FOR BUSINESS CODE',
                      style: FontStyleUtility.blackInter20W600.copyWith(color: colorWhite),
                    ),
                    20.heightBox,
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigation: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {},
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: 'By continuing, I agree to the ',
                    style: FontStyleUtility.blackInter16W400.copyWith(color: colorWhite, height: 1.5)),
                TextSpan(
                    text: 'Privacy Policy & Terms of Service.',
                    style: FontStyleUtility.blackInter16W400.copyWith(
                      color: colorWhite,
                      height: 1.5,
                      decoration: TextDecoration.underline,
                    )),
              ]),
            ),
          ),
        ));
  }
}
