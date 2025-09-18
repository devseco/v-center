import 'package:get/get.dart';
import 'package:ecommerce/controllers/RecentlyProducts_controller.dart';

class RecentlyProducts_bindings implements Bindings {
  @override
  void dependencies() {
    // استخدام put بدلاً من lazyPut لتجنب مشاكل إعادة الإنشاء
    Get.put(() => RecentlyProductsController(), permanent: false);
  }
}
