import 'package:get/get.dart';
import 'package:ecommerce/controllers/Cart_controller.dart';

class Cart_bindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => Cart_controller() ,fenix: true );
    // TODO: implement dependencies
  }

}