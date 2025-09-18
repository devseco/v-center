// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  int id;
  String title;
  int price;
  String description;
  String image;
  int category;

  Product(
      {required this.id,
      required this.title,
      required this.price,
      required this.description,
      required this.image,
      required this.category});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"] is String ? int.parse(json["id"]) : json["id"],
        title: json["title"],
        price:
            json["price"] is String ? int.parse(json["price"]) : json["price"],
        description: json["description"],
        image: json["image"],
        category: json["category"] is String
            ? int.parse(json["category"])
            : json["category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "description": description,
        "image": image,
        "category": category
      };
}
