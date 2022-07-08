import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:blinq/Utility/colors_utility.dart';
import 'package:blinq/Utility/font_style_utility.dart';

Color? borderColor;

OutlineInputBorder textFieldBorderStyle = OutlineInputBorder(
  borderSide: BorderSide(color: borderColor ?? colorBlack.withOpacity(0.1), width: 1),
  borderRadius: BorderRadius.circular(5.0),
);

Widget commonTextField(
    {String? fieldTitleText,
    required String hintText,
    String? labelText,
    bool isPassword = false,
    required TextEditingController? textEditingController,
    Function? validationFunction,
    Function? onSavedFunction,
    double? borderOpacity,
    Function? onFieldSubmit,
    TextInputType? keyboardType,
    Function? onEditingComplete,
    Function? onTapFunction,
    Function? onChangedFunction,
    TextAlign? align,
    TextInputAction? inputAction,
    List<TextInputFormatter>? inputFormatter,
    bool? isEnabled,
    int? errorMaxLines,
    int? maxLine,
    FocusNode? textFocusNode,
    GlobalKey<FormFieldState>? key,
    bool isReadOnly = false,
    Widget? suffixIcon,
    ExactAssetImage? preFixIcon,
    Widget? preFixWidget,
    Color? filledColor = textFieldColor,
    RxBool? showPassword,
    int? maxLength,
    EdgeInsetsGeometry? contentPadding,
    ScrollController? scrollController,
    TextStyle? hintStyle}) {
  bool passwordVisible = isPassword;
  return StatefulBuilder(builder: (context, newSetState) {
    borderColor = colorBlack.withOpacity(borderOpacity ?? 0.1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // if (fieldTitleText != null && fieldTitleText.isNotEmpty) fieldTitle(fieldTitleText),
        if (fieldTitleText != null && fieldTitleText.isNotEmpty)
          const SizedBox(
            height: 10.0,
          ),
        labelText == null || labelText.isEmpty
            ? const SizedBox()
            : Text(labelText, style: FontStyleUtility.blackInter16W500),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            maxLength: maxLength ?? 10000,
            scrollController: scrollController,
            // for scroll extra while keyboard open
            // scrollPadding: EdgeInsets.fromLTRB(20, 20, 20, 120),
            enabled: isEnabled != null && !isEnabled ? false : true,
            textAlign: align ?? TextAlign.start,
            showCursor: !isReadOnly,

            onTap: () {
              if (onTapFunction != null) {
                onTapFunction();
              }
            },
            key: key,
            focusNode: textFocusNode,
            onChanged: (value) {
              if (onChangedFunction != null) {
                onChangedFunction(value);
              }
            },
            onEditingComplete: () {
              if (onEditingComplete != null) {
                onEditingComplete();
              }
            },
            validator: (value) {
              return validationFunction != null ? validationFunction(value) : null;
            },
            // onSaved: onSavedFunction != null ? onSavedFunction : (value) {},
            onSaved: (value) {
              // ignore: void_checks
              return onSavedFunction != null ? onSavedFunction(value) : null;
            },
            onFieldSubmitted: (value) {
              // ignore: void_checks
              return onFieldSubmit != null ? onFieldSubmit(value) : null;
            },
            maxLines: maxLine ?? 1,
            keyboardType: keyboardType,
            controller: textEditingController,
            // initialValue: initialText,
            cursorColor: colorPrimary,
            obscureText: passwordVisible,
            textInputAction: inputAction ?? TextInputAction.next,

            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              color: textColor,
            ),
            inputFormatters: inputFormatter,
            decoration: InputDecoration(
              counterText: '',
              errorMaxLines: errorMaxLines ?? 1,
              filled: true,
              fillColor: filledColor,
              contentPadding: contentPadding ?? const EdgeInsets.fromLTRB(0, 15.0, 10.0, 15.0),
              // focusedBorder: OutlineInputBorder(
              //   borderSide: const BorderSide(color: colorSemiDarkBlack, width: 1),
              //   borderRadius: BorderRadius.circular(5.0),
              // ),
              // disabledBorder: textFieldBorderStyle,
              // enabledBorder: textFieldBorderStyle,
              // errorBorder: textFieldBorderStyle,
              // focusedErrorBorder: textFieldBorderStyle,

              labelText: hintText,
              // hintText: hintText,
              prefixIcon: preFixIcon != null
                  ? Image(
                      image: preFixIcon,
                      height: 15,
                      // color: color_8D8D8D,
                    )
                  : preFixWidget,
              suffixIcon: isPassword
                  ? InkWell(
                      onTap: () {
                        newSetState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                      child: passwordVisible
                          ? const Icon(
                              CupertinoIcons.eye,
                              // color: textColor,
                            )
                          : const Icon(
                              CupertinoIcons.eye_slash,
                              // color: textColor,
                            ))
                  : suffixIcon ??
                      const SizedBox(
                        height: 0,
                        width: 0,
                      ),
              hintStyle: hintStyle ??
                  FontStyleUtility.greyInter16W500.copyWith(
                      color: colorGrey.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ],
    );
  });
}

// Widget commonTextField(
//     {String? fieldTitleText,
//       required String hintText,
//       bool isPassword = false,
//       TextEditingController? textEditingController,
//       Function? validationFunction,
//       Function? onSavedFunction,
//       Function? onFieldSubmit,
//       TextInputType? keyboardType,
//       Function? onEditingComplete,
//       Function? onTapFunction,
//       Function? onChangedFunction,
//       TextAlign align = TextAlign.start,
//       TextInputAction? inputAction,
//       List<TextInputFormatter>? inputFormatter,
//       bool? isEnabled,
//       int? errorMaxLines,
//       // String? initialText = "",
//       int? maxLine,
//       FocusNode? textFocusNode,
//       GlobalKey<FormFieldState>? key,
//       bool isReadOnly = false,
//       Widget? suffixIcon,
//       Widget? preFixIcon}) {
//   OutlineInputBorder textFieldBorderStyle = OutlineInputBorder(
//     borderSide: BorderSide(color: colorBlack.withOpacity(0.1)),
//     borderRadius: commonButtonBorderRadius,
//   );
//   bool passwordVisible = isPassword;
//   return StatefulBuilder(builder: (context, newSetState) {
//     return Obx(() {
//       return TextFormField(
//         // for scroll extra while keyboard open
//         // scrollPadding: EdgeInsets.fromLTRB(20, 20, 20, 120),
//         enabled: isEnabled != null && !isEnabled ? false : true,
//         textAlign: align,
//         showCursor: !isReadOnly,
//         onTap: () {
//           if (onTapFunction != null) {
//             onTapFunction();
//           }
//         },
//         key: key,
//         focusNode: textFocusNode,
//         onChanged: (value) {
//           if (onChangedFunction != null) {
//             onChangedFunction(value);
//           }
//         },
//         onEditingComplete: () {
//           if (onEditingComplete != null) {
//             onEditingComplete();
//           }
//         },
//         validator: (value) {
//           return validationFunction != null ? validationFunction(value) : null;
//         },
//         // onSaved: onSavedFunction != null ? onSavedFunction : (value) {},
//         onSaved: (value) {
//           return onSavedFunction != null ? onSavedFunction(value) : null;
//         },
//         onFieldSubmitted: (value) {
//           return onFieldSubmit != null ? onFieldSubmit(value) : null;
//         },
//         maxLines: maxLine ?? 1,
//         keyboardType: keyboardType,
//         controller: textEditingController,
//         // initialValue: initialText,
//         obscureText: passwordVisible,
//         textInputAction: inputAction,
//         style: FontStyleUtility.blackDMSerifDisplay16W500,
//         inputFormatters: inputFormatter,
//         decoration: InputDecoration(
//           errorMaxLines: errorMaxLines ?? 1,
//           filled: true,
//           fillColor: colorWhite,
//           contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
//           focusedBorder: textFieldBorderStyle,
//           disabledBorder: textFieldBorderStyle,
//           enabledBorder: textFieldBorderStyle,
//           errorBorder: textFieldBorderStyle,
//           focusedErrorBorder: textFieldBorderStyle,
//           hintText: hintText,
//           prefixIcon: preFixIcon,
//           suffixIcon: isPassword
//               ? InkWell(
//               onTap: () {
//                 newSetState(() {
//                   passwordVisible = !passwordVisible;
//                 });
//               },
//               child: passwordVisible
//                   ? Obx(() {
//                           return const Icon(
//                   CupertinoIcons.eye_slash,
//                   color: colorGrey,
//                 );
//               })
//                   : Obx(() {
//                 return const Icon(
//                   CupertinoIcons.eye,
//                   color: colorGrey,
//                 );
//               }))
//               : suffixIcon,
//           hintStyle: FontStyleUtility.greyInter14W500,
//         ),
//       );
//     });
//   });
// }
