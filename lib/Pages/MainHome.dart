import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../api/connect.dart';
import 'Item.dart';
class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}
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
class _MainHomeState extends State<MainHome> {

  Future<void> getSlider() async {
    var url = Uri.parse(Apis.Api + 'home.php');

    http.Response response = await http.get(url);
    if(response.statusCode == 200){
      var data = json.decode(response.body);
      setState(() {
        sliders = data[0]['sliders'];
        items = data[0]['items'];
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewScreen()));
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Item(image:items[index]["image"] ,price: items[index]["price"],
                      title: items[index]["title"] , des: items[index]["des"], post: items[index]["id"],
                      )),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Image.network(items[index]["image"],
                            fit: BoxFit.fill, height: 100),
                        Text(items[index]["title"]),
                        Text("${items[index]["price"]} د.ع "),
                      ],
                    ),
                  ),
                );
                ;
              },
            ))
      ],
    );
  }
}
