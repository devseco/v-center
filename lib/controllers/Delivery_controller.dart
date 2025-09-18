import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce/controllers/Checkout_controller.dart';
import '../main.dart';
class Delivery_controller extends GetxController{
  List<String> governorates_en = [
    'Baghdad',
    'Basra',
    'Dhi Qar',
    'Wasit',
    'Maysan',
    'Muthanna',
    'Karbala',
    'Najaf',
    'Qadisiyah',
    'Babil',
    'Diyala',
    'Salah ad-Din',
    'Kirkuk',
    'Nineveh',
    'Erbil',
    'Dohuk',
    'Sulaymaniyah',
    'Al-Anbar',
  ];
  List<String> governorates_ar = [
    'بغداد',
    'البصرة',
    'ذي قار',
    'واسط',
    'ميسان',
    'المثنى',
    'كربلاء',
    'النجف',
    'القادسية',
    'بابل',
    'ديالى',
    'صلاح الدين',
    'كركوك',
    'نينوى',
    'اربيل',
    'دهوك',
    'السليمانية',
    'الانبار',
  ];
  int total = 0;
  int totalUser = 0;
  dynamic argumentData = Get.arguments;
  List<String> gonvernorates = [];
  String? selectedGovernorate ;
  late TextEditingController name  = TextEditingController();
  late TextEditingController phone  = TextEditingController();
 void changeSelect(value){
   selectedGovernorate = value;
   final Checkout_controller checkout_controller = Get.put(Checkout_controller());
   if(selectedGovernorate == 'بغداد'){
     checkout_controller.delivery = checkout_controller.delivery_Baghdad;
   }else{
     checkout_controller.delivery = checkout_controller.delivery_another;
   }
   checkout_controller.fullTotal =  checkout_controller.delivery + checkout_controller.total_user;
   update();
 }
  bool isValidPhoneNumber(String phoneNumber) {
    // التحقق من أن طول الرقم 11 وأنه يحتوي فقط على أرقام
    return phoneNumber.length == 11 && RegExp(r'^[0-9]+$').hasMatch(phoneNumber);
  }
 @override
  void onInit() {

   total = argumentData[0]['total'];
   totalUser = argumentData[0]['totalUser'];
   var sharePhone = sharedPreferences!.getString('phone')!;
   var nameSave = sharedPreferences!.getString('name')!;
   name.text = nameSave;
   phone.text = sharePhone;


   print('${sharePhone} is phone');
   gonvernorates = sharedPreferences!.getString('lang') == 'ar' ? governorates_ar : governorates_ar;

   //phone.text = ;
    // TODO: implement onInit
    super.onInit();
  }


}