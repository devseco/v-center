import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as ints;
import 'package:shimmer_pro/shimmer_pro.dart';
import '../api/connect.dart';
import 'Item.dart';
class Product {
  final String name;
  final String imageUrl;
  final String price;
  final String des;
  final String id;
  Product({required this.name, required this.imageUrl, required this.price, required this.des , required this.id});
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['title'],
      imageUrl: json['image'],
      price: json['price'],
      des: json['des'],
      id: json['id'],
    );
  }
}
List<Product> products = [];
class SparePartsPage extends StatefulWidget {
  final String? cat ;
  final String? brand ;
  SparePartsPage({required this.brand , required this.cat});
  @override
  _SparePartsPageState createState() => _SparePartsPageState();
}
bool loading = true;
late Color  bgColor = Colors.grey;
late ShimmerProLight shimmerlight = ShimmerProLight.darker;
class _SparePartsPageState extends State<SparePartsPage> {
  String searchString = '';

  Future<void> getItems() async {
    var url = Uri.parse(Apis.Api + 'items.php?brand=${widget.brand}&cat=${widget.cat}');
    http.Response response = await http.get(url);
    print(response.body);
    var data = json.decode(response.body);
    print(data);

    // قم بمعالجة البيانات المسترجعة وإضافتها إلى قائمة المنتجات
    List<Product> fetchedProducts = [];
    for (var item in data) {
      fetchedProducts.add(Product.fromJson(item));
    }
    loading = false;

    setState(() {
      products = fetchedProducts;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItems();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    List<Product> filteredProducts = products
        .where((product) =>
        product.name.toLowerCase().contains(searchString.toLowerCase()))
        .toList();

    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      appBar: AppBar(
        title: Text('${widget.brand } - ${widget.cat}'),
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchString = value;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  // Search icon inside the input field
                  hintText: "بحث ...",
                  // Placeholder text
                  border: InputBorder.none,
                  // Removes the border
                  hintStyle: TextStyle(
                    color: Color(0xFFBDBDBD).withOpacity(1.0),
                  ),
                ),
              )),
          (loading)?  Expanded(child: GridView.builder(
            itemCount: 6, // عدد المرات التي ترغب في تكرار العنصر
            itemBuilder: (context, index) {
              return ShimmerPro.sized(
                light: shimmerlight,
                scaffoldBackgroundColor: bgColor,
                height:  size.width / 3,
                width: size.width / 2,
                borderRadius: 2,
              );
            },  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // عدد العناصر في كل صف
            crossAxisSpacing: 2, // المسافة الأفقية بين العناصر
            mainAxisSpacing: 2, // المسافة الرأسية بين العناصر
            childAspectRatio: 1.0, // نسبة أبعاد العناصر
          ),
          ))
              :  Expanded(
                  child: GridView.builder(
                  padding: EdgeInsets.only(left: 5,right: 5),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewScreen()));
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Item(id: filteredProducts[index].id,
                        )),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      height: MediaQuery.of(context).size.height * 0.3, // نسبة مئوية هنا
                      child: Column(
                        children: [
                          Image.network(
                            filteredProducts[index].imageUrl,
                            height: MediaQuery.of(context).size.width / 3.5,
                            fit: BoxFit.fill,
                          ),
                          ListTile(
                            title:  SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                filteredProducts[index].name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            subtitle:  Text(
                              formattedTotalPrice(int.parse(filteredProducts[index].price)) + ' د.ع ',
                              style: TextStyle(fontSize: 15,color: Colors.black45),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
          ),
        ],
      ),
    ));
  }
  String formattedTotalPrice(price) {
    final formatter = ints.NumberFormat('#,###', 'ar_IQ');
    return formatter.format(price);
  }
}