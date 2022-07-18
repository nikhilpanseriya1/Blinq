import 'dart:async';

import 'package:blinq/App/Home/home_screen.dart';
import 'package:blinq/Utility/constants.dart';
import 'package:blinq/Utility/utility_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:velocity_x/velocity_x.dart';

import 'Authentication/start_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription? _dataStreamSubscription;

  String _sharedText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Receive text data when app is running
    _dataStreamSubscription = ReceiveSharingIntent.getTextStream().listen((String text) {
      setState(() {
        _sharedText = text;
        showLog('shred text OPEN ====>>>  $_sharedText');
      });
    });

    //Receive text data when app is closed
    ReceiveSharingIntent.getInitialText().then((String? text) {
      if (text != null) {
        setState(() {
          _sharedText = text;
          showLog('shred text CLOSE ====>>>  $_sharedText');
        });

      }
    });

    if (getIsLogin()) {
      kAuthenticationController.userId = getObject(PrefConstants.userId);
      Timer(const Duration(seconds: 2), () => Get.offAll(() => const HomeScreen()));
    } else {
      Timer(const Duration(seconds: 2), () => Get.offAll(() => const StartScreen()));
    }
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
                style: FontStyleUtility.blackDMSerifDisplay24W700.copyWith(color: colorWhite, letterSpacing: 1.5),
              )
            ],
          ),
        ));
  }
}
