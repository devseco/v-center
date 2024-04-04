import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:suggestion_input_field/suggestion_input_field.dart';

import '../api/connect.dart';
import 'Item.dart';
class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}
final TextEditingController _controller = TextEditingController();
int selectedIndex = 0;
final List<String> imgList = [
  'https://pbs.twimg.com/media/FNWKfidWQAIP3Jt.jpg:large',
  'https://fdn.gsmarena.com/imgroot/news/19/07/thats-iphone-ads-july/-1220x526/gsmarena_005.jpg',
  'https://i.ytimg.com/vi/6Ij9PiehENA/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLBCpOS4ENRW1V6JLnNMfLwEjIZqsw',
  'https://newsy.elsob7.com/wp-content/uploads/2024/01/Samsung-Galaxy-S24-Ultra.jpg'
];

final List<Map<String, dynamic>> myProducts = [
  {
    "imageUrl":
    "https://media.croma.com/image/upload/v1662703724/Croma%20Assets/Communication/Mobiles/Images/261934_qgssvy.png",
    "name": "iPhone 14 Pro max",
    "price": 19.99,
  },
  {
    "imageUrl":
    "https://media.croma.com/image/upload/v1662703724/Croma%20Assets/Communication/Mobiles/Images/261934_qgssvy.png",
    "name": "iPhone 14 Pro max",
    "price": 19.99,
  },
  {
    "imageUrl":
    "https://media.croma.com/image/upload/v1662703724/Croma%20Assets/Communication/Mobiles/Images/261934_qgssvy.png",
    "name": "iPhone 14 Pro max",
    "price": 19.99,
  },
  {
    "imageUrl":
    "https://media.croma.com/image/upload/v1662703724/Croma%20Assets/Communication/Mobiles/Images/261934_qgssvy.png",
    "name": "iPhone 14 Pro max",
    "price": 19.99,
  },
  {
    "imageUrl":
    "https://media.croma.com/image/upload/v1662703724/Croma%20Assets/Communication/Mobiles/Images/261934_qgssvy.png",
    "name": "iPhone 14 Pro max",
    "price": 19.99,
  },
  {
    "imageUrl":
    "https://media.croma.com/image/upload/v1662703724/Croma%20Assets/Communication/Mobiles/Images/261934_qgssvy.png",
    "name": "iPhone 14 Pro max",
    "price": 19.99,
  },
  // Add more products as needed
];
List sliders = [];
List items = [];
List prodects = [];
class Customer {
  final String id;
  final String name;
  Customer({required this.id, required this.name});
}
Customer? selectedCustomer;
class _MainHomeState extends State<MainHome> {

  Future<void> getSlider() async {
    var url = Uri.parse(Apis.Api + 'home.php');

    http.Response response = await http.get(url);
    if(response.statusCode == 200){
      var data = json.decode(response.body);
      setState(() {
        sliders = data[0]['sliders'];
        items = data[0]['items'];
        prodects = data[0]['search'];
      });
    } else {
      setState(() {
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSlider();
  }
  FutureOr<List<Customer>> fetchCustomerData(String filterText) async {
    // تحويل قائمة المنتجات إلى قائمة من العملاء بناءً على بنية البيانات
    List<Customer> customers = prodects.map((product) {
      return Customer(id: product['id'], name: product['title']);
    }).toList();

    // تطبيق عملية البحث على العملاء
    return customers
        .where((customer) =>
        customer.name.toLowerCase().contains(filterText.toLowerCase()))
        .toList();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.all(10),
            child:  SuggestionTextField<Customer>(



              value: selectedCustomer,
              suggestionFetch: (textEditingValue) =>
                  fetchCustomerData(textEditingValue.text),

              textFieldContent: TextFieldContent(
                decoration: const InputDecoration(
                  labelText: 'اختار المنتج',
                ),
              ),
              displayStringForOption: (option) => option.name,
              onSelected: (option) {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Item(id: option.id,
                    )),
                  );
                  selectedCustomer = option;

                });
              },

              onClose: () {
                setState(() {

                  selectedCustomer = null;
                  fetchCustomerData('');
                });

              },
            ),
        ),
        (sliders.isNotEmpty)? SizedBox(
          width: size.width ,
          child: CarouselSlider(

            options: CarouselOptions(autoPlay: true
              ,viewportFraction: 1,
            ),

            items: sliders
                .map((item) => Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white60)
              ),
              margin: EdgeInsets.all(15),
              child: Center(
                  child:
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: item['image'],
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,

                          ),
                        ),
                      ),
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  )
              ),
            ))
                .toList(),
          ),
        ) : Container(
          height: 200,
          child: Center(child: Text("جاري التحميل ..."),),
        ),
        SizedBox(
          height: 30,
        ),

        Center(child: Text("اخر المنتجات"),),

        SizedBox(
          height: 20,
        ),
        Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 20,

              ),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewScreen()));
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Item(id: items[index]['id'],
                      )),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 4,
                    child: Column(
                      children: [
                        Image.network(
                          items[index]['image'],
                          height: MediaQuery.of(context).size.width / 3.5,
                          fit: BoxFit.fill,
                        ),
                        ListTile(
                          title:  SizedBox(
                            //You can define in as your screen's size width,
                            //or you can choose a double
                            //ex:
                            //width: 100,
                            width: MediaQuery.of(context).size.width, //this is the total width of your screen
                            child: Text(
                              items[index]['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          subtitle:  Text(
                            formattedTotalPrice(int.parse(items[index]['price'])) + ' د.ع ',
                            style: TextStyle(fontSize: 15,color: Colors.black45),
                          ),
                        ),
                      ],
                    ),
                  ),


                );

              },
            )),
      ],
    );
  }
  String formattedTotalPrice(price) {
    final formatter = NumberFormat('#,###', 'ar_IQ');
    return formatter.format(price);
  }
}
