import 'package:blinq/Utility/utility_export.dart';
import 'package:flutter/material.dart';

Widget commonStructure({
  required BuildContext context,
  required Widget child,
  PreferredSize? appBar,
  Color? bgColor,
  double? padding,
  Widget? bottomNavigation,
}) {
  ///Pass null in appbar when it's optional ex = appBar : null
  return Stack(
    children: [
      Scaffold(
        backgroundColor: bgColor ?? colorWhite,
        resizeToAvoidBottomInset: true,
        appBar: appBar,
        bottomNavigationBar: bottomNavigation,

        ///adding listView cause scroll issue
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: padding ?? 12),
          height: MediaQuery.of(context).size.height,
          child: child,
        ),
      ),
    ],
  );
}
