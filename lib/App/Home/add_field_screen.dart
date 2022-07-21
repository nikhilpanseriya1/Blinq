import 'package:blinq/App/Home/Model/social_media_model.dart';
import 'package:blinq/Utility/utility_export.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../Utility/constants.dart';

class AddFieldScreen extends StatefulWidget {
  int index;
  bool isFromEdit;

  AddFieldScreen({Key? key, required this.index, required this.isFromEdit}) : super(key: key);

  @override
  State<AddFieldScreen> createState() => _AddFieldScreenState();
}

class _AddFieldScreenState extends State<AddFieldScreen> {
  TextEditingController mainController = TextEditingController();
  TextEditingController labelController = TextEditingController();
  RxString title = ''.obs;
  GlobalKey<FormState> formKey = GlobalKey();
  String selectedCountryCode = '+91';


  @override
  Widget build(BuildContext context) {
    return commonStructure(
      context: context,
      appBar: commonAppBar(title: 'Add ${kHomeController.socialMediaList[widget.index].name}', actionWidgets: [
        InkWell(
          highlightColor: colorWhite,
          splashColor: colorWhite,
          onTap: () {
            if (formKey.currentState!.validate()) {
              kHomeController.addFieldsModelList.add({
                'data': kHomeController.socialMediaList[widget.index].type == typePhone
                    ? '$selectedCountryCode ${mainController.text}'
                    : mainController.text,
                'label': labelController.text,
                'title': kHomeController.socialMediaList[widget.index].name
              });

              if (widget.isFromEdit) {
                /// Add field and update list
                var userRef = FirebaseFirestore.instance.doc('users/${kAuthenticationController.userId}');
                userRef.update({'fields': kHomeController.addFieldsModelList}).whenComplete(() async {
                  showLog('Data added successfully...');
                });
              }

              // kHomeController.addFieldsModelList.add(AddFieldsModel(
              //     data: kHomeController.socialMediaList[widget.index].type == typePhone
              //         ? '$selectedCountryCode ${mainController.text}'
              //         : mainController.text,
              //     label: titleController.text,
              //     title: kHomeController.socialMediaList[widget.index].name));

              Get.back();
            }
          },
          child: Center(
              child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text('SAVE', style: FontStyleUtility.blackDMSerifDisplay16W500.copyWith(color: colorRed)),
          )),
        ),
      ]),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              50.heightBox,
              Row(
                children: [
                  20.widthBox,
                  Container(
                    height: 60,
                    width: 60,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(color: colorPrimary, borderRadius: BorderRadius.circular(100)),
                    child: Image(
                      image: kHomeController.socialMediaList[widget.index].logo,
                      color: colorWhite,
                    ),
                  ),
                  20.widthBox,
                  Text(
                    kHomeController.socialMediaList[widget.index].name,
                    style: FontStyleUtility.blackInter16W500.copyWith(color: colorPrimary),
                  )
                ],
              ),
              30.heightBox,
              commonTextField(
                  preFixWidget: kHomeController.socialMediaList[widget.index].type == typePhone
                      ? SizedBox(
                          width: 110,
                          child: commonCountryCodePicker(
                            onChanged: (value) {
                              selectedCountryCode = value;
                              showLog(selectedCountryCode);
                            },
                            borderColor: colorWhite.withOpacity(0.0),
                            initialSelection: 'IN',
                            isShowDropIcon: false,
                          ),
                        )
                      : null,
                  hintText: kHomeController.socialMediaList[widget.index].hint,
                  maxLength: kHomeController.socialMediaList[widget.index].type == typePhone ? 14 : 500,
                  keyboardType: kHomeController.socialMediaList[widget.index].type == typePhone
                      ? TextInputType.number
                      : kHomeController.socialMediaList[widget.index].type == typeEmail
                          ? TextInputType.emailAddress
                          : TextInputType.text,
                  textEditingController: mainController,
                  validationFunction: (val) {
                    return kHomeController.socialMediaList[widget.index].type == typePhone
                        ? phoneValidationFunction(val)
                        : kHomeController.socialMediaList[widget.index].type == typeEmail
                            ? emailValidation(val)
                            : kHomeController.socialMediaList[widget.index].type == typeLink
                                ? urlValidation(val)
                                : emptyFieldValidation(val);
                  }),
              20.heightBox,
              commonTextField(
                hintText: 'Title (Optional)',
                textEditingController: labelController,
                onChangedFunction: (val) {
                  title.value = val;
                },
              ),
              20.heightBox,
              Text(
                'Here are some suggestions for you title:',
                style: FontStyleUtility.blackInter16W400,
              ),
              10.heightBox,
              Wrap(
                children: kHomeController.socialMediaList[widget.index].labels
                    .map((element) => InkWell(
                          splashColor: colorWhite,
                          highlightColor: colorWhite,
                          onTap: () {
                            labelController.text = element;
                            title.value = element;
                          },
                          child: Obx(
                            () => Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(color: colorBlack.withOpacity(0.5), width: 1),
                                  color: title.value == element ? colorRed : colorWhite),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    element,
                                    style: FontStyleUtility.blackInter14W500
                                        .copyWith(color: title.value == element ? colorWhite : colorBlack),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
