import 'package:get/get.dart';

import '../controllers/Checkout_controller.dart';

class Checkout_bindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Checkout_controller());
    // TODO: implement dependencies
  }

}