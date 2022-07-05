import 'package:blinq/App/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';

import 'Utility/utility_export.dart';

final getPreference = GetStorage();

// Future<void> main() async {
void main() async {
  // callMain();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      theme: ThemeData(
          accentColor: colorPrimary,
          scaffoldBackgroundColor: colorWhite,
          fontFamily: 'Inter',
          colorScheme: ThemeData().colorScheme.copyWith(primary: colorPrimary),
          unselectedWidgetColor: colorGrey,
          backgroundColor: colorWhite,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent
          // primarySwatch: Colors.blue,
          ),
      builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget!),
          maxWidth: MediaQuery.of(context).size.width,
          minWidth: 420,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(420, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(color: colorWhite)),
      home: const SplashScreen(),
    );
  }
}
