import 'package:get/get.dart';

import '../controllers/Products_controller.dart';

class Products_bindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => Products_Controller());
    // TODO: implement dependencies
  }

}