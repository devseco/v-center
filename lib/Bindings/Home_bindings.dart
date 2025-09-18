import 'package:get/get.dart';
import 'package:ecommerce/controllers/Home_controller.dart';

class Home_Bindings implements Bindings {
  @override
  void dependencies() {
    // استخدام put بدلاً من lazyPut مع fenix لتجنب مشاكل إعادة الإنشاء
    Get.put(() => Home_controller(), permanent: false);
  }
}
