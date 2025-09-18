// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

List<UserInfo> userInfoFromJson(String str) => List<UserInfo>.from(json.decode(str).map((x) => UserInfo.fromJson(x)));

String userInfoToJson(List<UserInfo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserInfo {
  int id;
  String name;
  String phone;
  String city;
  String address;
  String password;
  dynamic point;
  int active;

  UserInfo({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
    required this.address,
    required this.password,
    required this.point,
    required this.active,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    city: json["city"],
    address: json["address"],
    password: json["password"],
    point: json["point"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "city": city,
    "address": address,
    "password": password,
    "point": point,
    "active": active,
  };
}
