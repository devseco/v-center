import 'package:hive/hive.dart';
part 'CartModel.g.dart';
@HiveType(typeId: 1)
class CartModel {
  @HiveField(0)
  String title;
  @HiveField(1)
  int price;
  @HiveField(2)
  int count;
  @HiveField(3)
  String image;
  @HiveField(4)
  int category;
  @HiveField(5)
  int item;
  @HiveField(6)
  int id;
  @HiveField(7)
  String color;
  @HiveField(8)
  String size;
  CartModel({
    required this.price,
    required this.title,
    required this.count,
    required this.image,
    required this.category,
    required this.item,
    required this.id,
    required this.color,
    required this.size,
  });
}