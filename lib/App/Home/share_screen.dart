import 'dart:core';

import 'package:blinq/App/Home/your_card_screen.dart';
import 'package:blinq/Utility/utility_export.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ShareScreen extends StatefulWidget {
  String cardId;

  ShareScreen({Key? key, required this.cardId}) : super(key: key);

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController msgController = TextEditingController();
  String selectedCountryCode = '+91';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    msgController.text = 'Hi, This is $appName card, Copy this id and add this business card on $appName: ';
  }

  @override
  Widget build(BuildContext context) {
    return commonStructure(
        appBar: commonAppBar(title: 'Text Your Card'),
        context: context,
        child: InkWell(
          splashColor: colorWhite,
          highlightColor: colorWhite,
          focusColor: colorWhite,
          onTap: () {
            disableFocusScopeNode(context);
          },
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                50.heightBox,
                commonTextField(
                    preFixWidget: SizedBox(
                      width: 110,
                      child: commonCountryCodePicker(
                        onChanged: (value) {
                          selectedCountryCode = value;
                        },
                        borderColor: colorWhite.withOpacity(0.0),
                        initialSelection: 'IN',
                        isShowDropIcon: false,
                      ),
                    ),
                    maxLength: 14,
                    keyboardType: TextInputType.number,
                    hintText: 'Enter contact number',
                    textEditingController: phoneController,
                    validationFunction: (val) {
                      return phoneValidationFunction(val);
                    }),
                20.heightBox,
                Text(
                  'Enter your message...',
                  style: FontStyleUtility.blackInter16W500,
                ),
                20.heightBox,
                commonTextField(
                  hintText: 'EntQer your message',
                  maxLine: 3,
                  contentPadding: EdgeInsets.all(15),
                  outlineInputBorder: textFieldBorderStyle,
                  textEditingController: msgController,
                ),
                20.heightBox,
                Text(
                  '${widget.cardId}',
                  style: FontStyleUtility.blackInter16W500,
                ),
                30.heightBox,
                commonFillButtonView(
                    title: 'Send',
                    tapOnButton: () {
                      sendSms(
                          contactNumber: '$selectedCountryCode${phoneController.text}',
                          msg: '${msgController.text} \n\n ${widget.cardId}');
                    })
              ],
            ),
          ),
        ));
  }
}
