import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ecommerce/Bindings/Landing_bindings.dart';
import 'package:ecommerce/Services/RemoteServices.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/views/Landing.dart';

class Login_controller extends GetxController {
  //variable for check Remember me
  late bool isremember = false;
  late bool loading = false;
  late bool errorlogin = false;
  late String errormsg = '';
  late TextEditingController phone_ = TextEditingController();
  late TextEditingController password_ = TextEditingController();
  //void for check Remember me
  void is_checking() {
    if (isremember) {
      isremember = false;
    } else {
      isremember = true;
    }
    update();
  }

  void is_loading() {
    loading = true;
    update();
  }

  void isnot_loading() {
    loading = false;
    update();
  }

  void is_error() {
    errorlogin = true;
    update();
  }

  void Login() async {
    // التحقق من الحقول
    if (phone_.text.isEmpty && password_.text.isEmpty) {
      errormsg = "يرجى إدخال رقم الهاتف وكلمة المرور.";
      is_error();
      return;
    } else if (phone_.text.isEmpty) {
      errormsg = "يرجى إدخال رقم الهاتف.";
      is_error();
      return;
    } else if (password_.text.isEmpty) {
      errormsg = "يرجى إدخال كلمة المرور.";
      is_error();
      return;
    }

    // التحقق من صحة رقم الهاتف
    if (phone_.text.length != 11) {
      errormsg =
          "رقم الهاتف غير صحيح. يجب أن يكون 11 رقم (رقم هاتف عراقي صحيح).";
      is_error();
      return;
    }

    // التحقق من أن رقم الهاتف يبدأ بـ 07
    if (!phone_.text.startsWith('07')) {
      errormsg =
          "رقم الهاتف غير صحيح. يجب أن يبدأ بـ 07 (رقم هاتف عراقي صحيح).";
      is_error();
      return;
    }

    if (phone_.text.isNotEmpty && password_.text.isNotEmpty) {
      is_loading();
      var response = await RemoteServices.login(
        phone_.text.trim(),
        password_.text.trim(),
      );
      if (response != null) {
        var json_response = jsonDecode(response);
        if (json_response['message'] == "Login Successfully") {
          print(json_response);
          await sharedPreferences!.setString('phone', json_response['phone']);
          await sharedPreferences!.setInt('user_id', json_response['user_id']);
          await sharedPreferences!.setString('near', json_response['near']);
          await sharedPreferences!.setInt('active', json_response['active']);
          await sharedPreferences!.setString('name', json_response['username']);
          if (isremember) {
            await sharedPreferences!.setBool('remember', true);
          }
          isnot_loading();
          Get.off(() => Landing(), binding: Landing_bindings());
        } else if (json_response['message'] == "No user found") {
          errormsg =
              "رقم الهاتف أو كلمة المرور غير صحيحة. يرجى التحقق من بياناتك والمحاولة مرة أخرى.";
          is_error();
          print(json_response['message']);
          isnot_loading();
        } else if (json_response['message'] == "Invalid credentials") {
          errormsg =
              "بيانات الدخول غير صحيحة. تأكد من رقم الهاتف وكلمة المرور.";
          is_error();
          print(json_response['message']);
          isnot_loading();
        } else if (json_response['message'] == "User not found") {
          errormsg = "لم يتم العثور على المستخدم. تأكد من أن الحساب موجود.";
          is_error();
          print(json_response['message']);
          isnot_loading();
        } else if (json_response['message'] == "Account is disabled") {
          errormsg = "الحساب معطل. يرجى التواصل مع الدعم الفني.";
          is_error();
          print(json_response['message']);
          isnot_loading();
        } else if (json_response['message'] == "Invalid phone number") {
          errormsg =
              "رقم الهاتف غير صحيح. تأكد من إدخال رقم هاتف عراقي صحيح (11 رقم يبدأ بـ 07).";
          is_error();
          print(json_response['message']);
          isnot_loading();
        } else {
          errormsg = "حدث خطأ أثناء تسجيل الدخول. يرجى المحاولة مرة أخرى.";
          is_error();
          print(json_response['message']);
          isnot_loading();
        }
      } else {
        errormsg =
            "فشل الاتصال بالخادم. تحقق من اتصال الإنترنت وحاول مرة أخرى.";
        is_error();
        isnot_loading();
      }
    } else {
      errormsg = "يرجى ملء جميع الحقول المطلوبة (رقم الهاتف وكلمة المرور).";
      is_error();
    }
  }
}
