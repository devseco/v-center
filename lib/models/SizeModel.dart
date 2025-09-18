// To parse this JSON data, do
//
//     final sizeModel = sizeModelFromJson(jsonString);

import 'dart:convert';

List<SizeModel> sizeModelFromJson(String str) => List<SizeModel>.from(json.decode(str).map((x) => SizeModel.fromJson(x)));

String sizeModelToJson(List<SizeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SizeModel {
  int id;
  String size;
  int color;
  int count;

  SizeModel({
    required this.id,
    required this.size,
    required this.color,
    required this.count,
  });

  factory SizeModel.fromJson(Map<String, dynamic> json) => SizeModel(
    id: json["id"],
    size: json["size"],
    color: json["color"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "size": size,
    "color": color,
    "count": count,
  };
}
