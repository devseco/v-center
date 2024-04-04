import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intal;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../api/connect.dart';

class Item extends StatefulWidget {
  final String? id ;
  const Item({required this.id });

  @override
  State<Item> createState() => _ItemState();
}

int selectedIndex = 0;

List items = [];
bool loading = true;
final List<double> prices = [
  100000
];
bool isFavoriteClicked = true; // متغير لتتبع حالة نقر أيقونة الإعجاب

class _ItemState extends State<Item> {
  int quantity = 1; // الكمية الافتراضية

  void increaseQuantity() {
    setState(() {
      quantity++; // زيادة الكمية
    });
  }

  void decreaseQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--; // تقليل الكمية بشرط ألا تكون أقل من 1
      }
    });
  }
  String formattedTotalPrice(price) {
    final formatter = intal.NumberFormat('#,###', 'ar_IQ');
    return formatter.format(price);
  }

  Future<void> get_Items() async {
    var url = Uri.parse(Apis.Api + 'item.php?id='+widget.id!);
    http.Response response = await http.get(url);
    print(response.body);
    var data = json.decode(response.body);
    print(data);
    setState(() {
      items = data;
      loading = false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_Items();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            actions: [

              Padding(
                padding: EdgeInsets.only(top: 10, left: 15),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.share,
                    color: Colors.blue, // تغيير اللون بناءً على الحالة
                  ),
                ),
              ),
            ],
          ),
          body: (loading)? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.green,
                size: 100,
              )) : Column(
            children: [
              Container(
                height: size.height / 2.5,
                width: size.width,
                child:  Image.network(items[0]['image'] , fit: BoxFit.cover,),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      items[0]['title'],
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  children: [
                    Text('${formattedTotalPrice(int.parse(items[0]['price']))} د.ع ',
                        style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    items[0]['des'],
                    style: TextStyle(fontSize: 17, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0), // مسافة داخلية حول الأيقونات والنص
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey), // لون الإطار
                      borderRadius: BorderRadius.circular(10.0), // تقريب زوايا الإطار
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // لجعل الصف يأخذ أقل مساحة ممكنة
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: decreaseQuantity, // تقليل الكمية
                        ),
                        Text(
                          '$quantity', // عرض الكمية
                          style: TextStyle(fontSize: 20),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: increaseQuantity, // زيادة الكمية
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  // Add some padding around the button
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                         add_cart(items[0]['id'], "2", items[0]['image'], quantity.toString(), items[0]['title'], items[0]['price']);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                          ),
                          minimumSize: Size(200, 60), // Set the button's size
                        ),
                        child: Text('اضافة الى السلة',
                            style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(width: 20),
                      // Spacing between button and price
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
  void add_cart(String post , String user , String image , String count , String title , String price  ) async {
    var url1 = Uri.parse(
        Apis.Api  + 'add_cart.php?user='+ user+  '&post= '+ post+ '&price=' + price + '&title=' + title + '&image=' + image + '&count=' + count
    );
    http.Response response = await http.get(url1);
    print(response.body);
    //var data = json.decode(response.body);

    if(response.body.toString().contains("Successfully")){
      QuickAlert.show(
        confirmBtnText: "رجوع",
        context: context,
        title: "تمت الاضافة",
        type: QuickAlertType.success,
        text: "تمت اضافة المنتج الى سلة المشتريات",
      );
    setState(() {
      quantity = 1;
    });
    }else{
      QuickAlert.show(
        confirmBtnText: "رجوع",
        context: context,
        title: "تعذر الاضافة",
        type: QuickAlertType.success,
        text: "حدث خطا في اضافة المنتج الى سلة المشتريات",
      );
    }


  }
}
