import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:suggestion_input_field/suggestion_input_field.dart';
import '../api/connect.dart';
import 'Item.dart';
class MainHome extends StatefulWidget {
  const MainHome({super.key});
  @override
  State<MainHome> createState() => _MainHomeState();
}
int selectedIndex = 0;
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
    List<Customer> customers = prodects.map((product) {
      return Customer(id: product['id'], name: product['title']);
    }).toList();
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
                decoration:  InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                  ), borderRadius: BorderRadius.circular(10.0),
                ),
                  prefixIcon: Icon(Icons.search),
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
          width: size.width / 1 ,
          height: size.width / 2 ,
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
              padding: EdgeInsets.symmetric(horizontal: 5),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2, // تحديد عدد العناصر في الصف الواحد بناءً على عرض الشاشة
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Item(id: items[index]['id'])),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          items[index]['image'],
                          height:  size.height * 0.13,
                          fit: BoxFit.fill,
                        ),
                        ListTile(
                          title: Text(
                            items[index]['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: size.height * 0.013,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            formattedTotalPrice(int.parse(items[index]['price'])) + ' د.ع ',
                            style: TextStyle(fontSize: 15, color: Colors.black45),
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
    );
  }
  String formattedTotalPrice(price) {
    final formatter = NumberFormat('#,###', 'ar_IQ');
    return formatter.format(price);
  }
}
