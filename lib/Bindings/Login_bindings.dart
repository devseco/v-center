import 'package:get/get.dart';
import 'package:ecommerce/controllers/Login_controller.dart';

class Login_Bindings implements Bindings {
        @override
        void dependencies() {
          Get.lazyPut<Login_controller>(() => Login_controller());
        }
     }