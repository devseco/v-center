import 'dart:convert';
List<SliderBar> sliderFromJson(String str) => List<SliderBar>.from(json.decode(str).map((x) => SliderBar.fromJson(x)));
String sliderToJson(List<SliderBar> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class SliderBar {
  int id;
  String title;
  String image;
  SliderBar({
    required this.id,
    required this.title,
    required this.image,
  });
  factory SliderBar.fromJson(Map<String, dynamic> json) => SliderBar(
    id: json["id"],
    title: json["title"],
    image: json["image"],
  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": image,
  };
}
