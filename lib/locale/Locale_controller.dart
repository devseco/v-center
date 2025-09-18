import 'dart:ui';
import 'package:get/get.dart';
import 'package:ecommerce/main.dart';
class Locale_controller extends GetxController {
  Locale inliaLang = sharedPreferences!.getString('lang') == 'ar' ? Locale('ar') : Locale('ar');
  void changelocale() {
    if(Get.locale.toString().contains('ar')){
      Locale locale = Locale('en');
      sharedPreferences!.setString('lang', 'en');
      Get.updateLocale(locale);
    }else{
      Locale locale = Locale('ar');
      sharedPreferences!.setString('lang', 'ar');
      Get.updateLocale(locale);
    }
  }

}