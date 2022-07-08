import 'package:blinq/Utility/utility_export.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'common_widgets.dart';

Widget commonFillButtonView(
    {
// required BuildContext context,
    required String title,
    required Function() tapOnButton,
    // required bool isLoading,
    bool isLightButton = false,
    Color? color,
    Color? fontColor,
    Widget? child,
    double? height = 60.0,
    double? width}) {
  return Builder(
    builder: (BuildContext context) {
      return Container(
        width: width ?? getScreenWidth(context) - 20,
        height: height,
        decoration: BoxDecoration(color: color ?? colorPrimary, borderRadius: BorderRadius.circular(50)),
        child: TextButton(
            onPressed: tapOnButton,
            child: child ??
                Text(
                  title,
                  style: FontStyleUtility.blackInter16W600.copyWith(color: fontColor ?? colorWhite),
                )),
      );
    },
  );
}

Widget commonMediaButtonView(
    {
// required BuildContext context,
    required Function() tapOnButton,
    // required bool isLoading,
    required Image prefixIcon,
    Color? color,
    double? height = 50,
    double? width}) {
  return Builder(
    builder: (BuildContext context) {
      return SizedBox(
          width: width ?? 50,
          height: height,
          child: Container(
            decoration: BoxDecoration(
              color: color ?? colorWhite,
              borderRadius: BorderRadius.circular(7),
            ),
            child: InkWell(
              highlightColor: color ?? colorWhite,
              splashColor: color ?? colorWhite,
              onTap: tapOnButton,
              child: Padding(
                padding: const EdgeInsets.only(left: 0, right: 0),
                child: prefixIcon,

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     prefixIcon ?? const SizedBox(),
                //     widthBox(width: 10),
                //     commonText(
                //       text: title,
                //       style: FontStyleUtility.blackInter16W600.copyWith(color: fontColor ?? textColor),
                //     ),
                //   ],
                // ),
              ),
            ),
          ));
    },
  );
}

Widget commonButtonView(
    {
// required BuildContext context,
    required String title,
    required Function() tapOnButton,
    // required bool isLoading,
    bool isLightButton = false,
    Image? suffixImage,
    Image? prefixImage,
    Color? color,
    Color? fontColor,
    TextStyle? textStyle,
    double? height = 60.0,
    double? fontSize = 18,
    double? width}) {
  return Builder(
    builder: (BuildContext context) {
      return SizedBox(
          width: width ?? MediaQuery.of(context).size.width - 20,
          height: height,
          child: Container(
            decoration: BoxDecoration(
              color: color ?? colorWhite,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: colorBlack.withOpacity(0.1), width: 1),
            ),
            child: InkWell(
              highlightColor: colorWhite,
              onTap: tapOnButton,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    suffixImage == null
                        ? Expanded(
                            child: Center(
                              child: Text(
                                title,
                                style: textStyle ??
                                    FontStyleUtility.blackInter16W600
                                        .copyWith(color: fontColor ?? colorBlack),
                              ),
                            ),
                          )
                        : Text(
                            title,
                            style: textStyle ??
                                FontStyleUtility.blackInter16W600.copyWith(color: fontColor ?? colorBlack),
                          ),
                    suffixImage ?? const SizedBox()
                  ],
                ),
              ),
            ),
          ));
    },
  );
}

Widget commonRoundedCornerButton({required Function() onTap, required String title, Widget? icon}) {
  return InkWell(
    onTap: onTap,
    highlightColor: colorWhite,
    child: Container(
      decoration:
          BoxDecoration(color: colorDarkBlue.withOpacity(0.5), borderRadius: BorderRadius.circular(25)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: FontStyleUtility.blackInter16W600.copyWith(color: colorWhite, fontSize: 18)),
          10.widthBox,
          SizedBox(child: icon ?? const SizedBox()),
        ],
      ),
    ),
  );
}
