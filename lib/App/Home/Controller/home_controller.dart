import 'package:blinq/App/Home/Model/social_media_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../Utility/constants.dart';
import '../../../Utility/utility_export.dart';

class HomeController extends GetxController {
  RxList<String> cardId = <String>[].obs;
  bool getSubCards = true;
  var userRef = FirebaseFirestore.instance.doc('users/${kAuthenticationController.userId}');
  var mainUserData;
  RxList<String> userContacts = <String>[].obs;

  // RxList<AddFieldsModel> addFieldsModelList = <AddFieldsModel>[].obs;
  RxList<Map<String, dynamic>> addFieldsModelList = <Map<String, dynamic>>[].obs;

  RxList<SocialMediaModel> socialMediaList = [
    SocialMediaModel(
        name: 'Phone Number',
        logo: phoneCall,
        hint: 'Phone Number',
        type: typePhone,
        labels: ['Call', 'Mobile', 'Work', 'Home']),
    SocialMediaModel(name: 'Email', logo: email, hint: 'Email', type: typeEmail, labels: ['Work', 'Personal']),
    SocialMediaModel(name: 'Link', logo: link, hint: 'URL', type: typeLink, labels: []),
    SocialMediaModel(
        name: 'Location',
        logo: location,
        hint: 'Company Address',
        type: typeString,
        labels: ['Work', 'Office', 'Home', 'Mailing Address']),
    SocialMediaModel(
        name: 'Company Website',
        logo: website,
        hint: 'Company Website',
        type: typeLink,
        labels: ['Company Name', 'Visit our website']),
    SocialMediaModel(
        name: 'LinkedIn', logo: linkedin, hint: 'URL', type: typeLink, labels: ['Connect with me on LinkedIn']),
    SocialMediaModel(
        name: 'Instagram', logo: instagram, hint: 'URL', type: typeLink, labels: ['Follow me on Instagram']),
    SocialMediaModel(name: 'Twitter', logo: twitter, hint: 'URL', type: typeLink, labels: ['Follow me on Twitter']),
    SocialMediaModel(name: 'Facebook', logo: facebook, hint: 'URL', type: typeLink, labels: ['Friend me on Facebook']),
    SocialMediaModel(
        name: 'Snapchat',
        logo: snapchat,
        hint: 'URL',
        type: typeLink,
        labels: ['Add me on Snapchat', 'Send me a snap']),
    SocialMediaModel(name: 'Tiktok', logo: tiktok, hint: 'URL', type: typeLink, labels: ['Follow me on TikTok']),
    SocialMediaModel(
        name: 'YouTube', logo: youtube, hint: 'URL', type: typeLink, labels: ['Subscribe to my channel on YouTube']),
    SocialMediaModel(
        name: 'Github',
        logo: github,
        hint: 'URL',
        type: typeLink,
        labels: ['View our work on GirHub', 'View our GitHub Repo']),
    SocialMediaModel(name: 'Yelp', logo: yelp, hint: 'URL', type: typeLink, labels: ['View our business on Yelp']),
    SocialMediaModel(name: 'Paypal', logo: paypal, hint: 'URL', type: typeLink, labels: []),
    SocialMediaModel(name: 'Discord', logo: discord, hint: 'URL', type: typeLink, labels: ['Join our Discord server']),
    SocialMediaModel(
        name: 'Signal', logo: signal, hint: 'Phone Number', type: typePhone, labels: ['Connect with me on Signal']),
    SocialMediaModel(
        name: 'Skype', logo: skype, hint: 'User name', type: typeString, labels: ['Skype with me', 'Call me on Skype']),
    SocialMediaModel(
        name: 'Telegram', logo: telegram, hint: 'URL', type: typeLink, labels: ['Connect with me on Telegram']),
    SocialMediaModel(name: 'Twitch', logo: twitch, hint: 'URL', type: typeLink, labels: ['Follow me on Twitch']),
    SocialMediaModel(
        name: 'WhatsApp',
        logo: whatsapp,
        hint: 'WhatsApp Phone Number',
        type: typePhone,
        labels: ['Connect with me on WhatsApp', 'Add me on WhatsApp']),
  ].obs;
}
