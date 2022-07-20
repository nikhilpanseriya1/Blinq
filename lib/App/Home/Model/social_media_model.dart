import 'package:flutter/material.dart';

class SocialMediaModel {
  String name;
  ExactAssetImage logo;
  String hint;
  String type;
  List<String> labels;

  SocialMediaModel(
      {required this.name, required this.logo, required this.hint, required this.type, required this.labels});
}

class AddFieldsModel {
  String data;
  String label;
  String title;

  AddFieldsModel({required this.data, required this.label, required this.title});
}


class contactList {
  String name;
  String companyName;
  String jobTitle;
  String profilePic;

  contactList({required this.name, required this.companyName, required this.jobTitle, required this.profilePic});
}
