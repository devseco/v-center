import 'package:hive_flutter/hive_flutter.dart';
import '../models/CartModel.dart';
import '../models/FavoriteModel.dart';

class HiveBoxes {
  static late Box<CartModel> cartBox;
  static late Box<FavoriteModel> favoriteBox;

  static Future<void> initialize() async {
    cartBox = await Hive.openBox<CartModel>('BoxCart');
    favoriteBox = await Hive.openBox<FavoriteModel>('Favorite');
  }
}
