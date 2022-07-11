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
