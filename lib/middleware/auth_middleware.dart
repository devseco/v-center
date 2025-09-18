import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ecommerce/main.dart';
class auth_middleware extends GetMiddleware{
  @override
  RouteSettings? redirect(String? route) {
    if(sharedPreferences!.getBool('remember') == true){
      return RouteSettings(name: '/landing' , );
    }
    return null;
  }
}