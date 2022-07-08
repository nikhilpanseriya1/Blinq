import 'package:blinq/App/Home/Model/social_media_model.dart';
import 'package:get/get.dart';

import '../../../Utility/utility_export.dart';

class HomeController extends GetxController {
  RxList<SocialMediaModel> socialMediaList = [
    SocialMediaModel(name: 'Phone Number', logo: phoneCall),
    SocialMediaModel(name: 'Email', logo: email),
    SocialMediaModel(name: 'Link', logo: link),
    SocialMediaModel(name: 'Location', logo: location),
    SocialMediaModel(name: 'Company\nWebsite', logo: website),
    SocialMediaModel(name: 'LinkedIn', logo: linkedin),
    SocialMediaModel(name: 'Instagram', logo: instagram),
    SocialMediaModel(name: 'Twitter', logo: twitter),
    SocialMediaModel(name: 'Facebook', logo: facebook),
    SocialMediaModel(name: 'Snapchat', logo: snapchat),
    SocialMediaModel(name: 'Tiktok', logo: tiktok),
    SocialMediaModel(name: 'YouTube', logo: youtube),
    SocialMediaModel(name: 'Github', logo: github),
    SocialMediaModel(name: 'Yelp', logo: yelp),
    SocialMediaModel(name: 'Paypal', logo: paypal),
    SocialMediaModel(name: 'Discord', logo: discord),
    SocialMediaModel(name: 'Signal', logo: signal),
    SocialMediaModel(name: 'Skype', logo: skype),
    SocialMediaModel(name: 'Telegram', logo: telegram),
    SocialMediaModel(name: 'Twitch', logo: twitch),
    SocialMediaModel(name: 'WhatsApp', logo: whatsapp),
  ].obs;
}
