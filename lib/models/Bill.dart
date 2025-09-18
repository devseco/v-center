// To parse this JSON data, do
//
//     final bill = billFromJson(jsonString);

import 'dart:convert';

List<Bill> billFromJson(String str) => List<Bill>.from(json.decode(str).map((x) => Bill.fromJson(x)));

String billToJson(List<Bill> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Bill {
  int id;
  String name;
  String phone;
  String city;
  String address;
  int status;
  String date;
  int price;
  int delivery;
  int userId;
  String? nearpoint;
  String? note;

  Bill({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
    required this.address,
    required this.status,
    required this.date,
    required this.price,
    required this.delivery,
    required this.userId,
    required this.nearpoint,
    required this.note,
  });

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    city: json["city"],
    address: json["address"],
    status: json["status"],
    date: json["date"],
    price: json["price"],
    delivery: json["delivery"],
    userId: json["user_id"],
    nearpoint: json["nearpoint"],
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "city": city,
    "address": address,
    "status": status,
    "date": date,
    "price": price,
    "delivery": delivery,
    "user_id": userId,
    "nearpoint": nearpoint,
    "note": note,
  };
}
