import 'package:hive/hive.dart';
part 'FavoriteModel.g.dart';
@HiveType(typeId: 2)
class FavoriteModel {
  @HiveField(0)
  String title;
  @HiveField(1)
  int price;
  @HiveField(2)
  int lastprice;
  @HiveField(3)
  String image;
  @HiveField(4)
  String rate;
  @HiveField(5)
  int item;
  @HiveField(6)
  int id;
  FavoriteModel({
    required this.price,
    required this.title,
    required this.rate,
    required this.image,
    required this.lastprice,
    required this.item,
    required this.id,
  });
}