import 'package:get/get.dart';
import 'package:ecommerce/controllers/Billing_controller.dart';
import 'package:ecommerce/controllers/Home_controller.dart';
import 'package:ecommerce/controllers/Landing_controller.dart';
import 'package:ecommerce/controllers/Login_controller.dart';
import 'package:ecommerce/controllers/ProfileController.dart';
import '../controllers/Cart_controller.dart';

class Landing_bindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Login_controller(), fenix: true);
    Get.lazyPut(() => Landing_controller(), fenix: true);
    Get.lazyPut<Home_controller>(() => Home_controller(), fenix: true);
    Get.lazyPut(() => Cart_controller(), fenix: true);
    Get.lazyPut(() => Billing_controller(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
  }
}
