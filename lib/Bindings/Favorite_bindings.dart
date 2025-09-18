import 'package:get/get.dart';
import 'package:ecommerce/views/Favorites.dart';

class Favorite_bindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => Favorites() , fenix: true);
    // TODO: implement dependencies
  }

}