import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ecommerce/models/FavoriteModel.dart';

late Box BoxFavorite;

class Favorite_controller extends GetxController {
  void putDate(title, price, id, image, category, lastprice, rate) {
    BoxFavorite.put(
        id,
        FavoriteModel(
            price: price,
            title: title,
            rate: rate,
            image: image,
            lastprice: lastprice,
            item: id,
            id: id));
    update();
  }

  bool getStatus(id) {
    var result = BoxFavorite.containsKey(id);
    return result;
  }

  void deleteAll() {
    BoxFavorite.clear();
    update();
  }

  void is_existsloading(id) {
    final box = Hive.box<FavoriteModel>("Favorite");
    final Map<dynamic, FavoriteModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.id == id) desiredKey = key;
    });
    box.delete(desiredKey);
    getStatus(id);
    update();
  }

  @override
  void onInit() {
    //BoxFavorite.clear();
    // TODO: implement onInit
    super.onInit();
  }
}
