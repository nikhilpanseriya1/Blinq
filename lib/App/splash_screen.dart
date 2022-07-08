import 'dart:async';

import 'package:blinq/App/Home/home_screen.dart';
import 'package:blinq/Utility/utility_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'Authentication/start_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getIsLogin()
        ? Timer(const Duration(seconds: 2), () => Get.to(() => const HomeScreen()))
        : Timer(const Duration(seconds: 2), () => Get.to(() => const StartScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return commonStructure(
        context: context,
        bgColor: colorRed,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                    image: appIcon,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  )),
              20.heightBox,
              Text(
                'Welcome to Blinq',
                style: FontStyleUtility.blackDMSerifDisplay24W700
                    .copyWith(color: colorWhite, letterSpacing: 1.5),
              )
            ],
          ),
        ));
  }
}
