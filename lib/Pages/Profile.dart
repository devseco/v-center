import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_pro/shimmer_pro.dart';

import '../api/connect.dart';
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}
late SharedPreferences prefs;
String id = "";
String name = "";
late Color  bgColor = Colors.grey;
late ShimmerProLight shimmerlight = ShimmerProLight.darker;
String formattedTotalPrice(price) {
  final formatter = NumberFormat('#,###', 'ar_IQ');
  return formatter.format(price);
}
List items = [];
String total_done = "0";
String total_driver = "0";
String total_loading = "0";
bool loading = true;

class _ProfileState extends State<Profile> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ()async{
      prefs = await SharedPreferences.getInstance();
      name = prefs.getString("name")!;
      id = prefs.getString("id")!;
      get_Items(id);
    }();

  }
  Future<void> get_Items(String idd) async {
    var url = Uri.parse(Apis.Api + 'bills.php?id='+ idd +'&limit=4');
    print(url);
    http.Response response = await http.get(url);
    print(response.body);
    var data = json.decode(response.body);
    print(data);
    setState(() {
      items = data['items'];
      loading = false;
      total_done =  data['stats']['stat_done'].toString();
      total_driver =  data['stats']['stat_dliver'].toString();
      total_loading =  data['stats']['stat_loading'].toString();
    });
  }

  int counter = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(


      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex:5,
                child:Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Column(
                      children: [
                        SizedBox(height: 110.0,),
                        CircleAvatar(
                          radius: 65.0,
                          backgroundImage: AssetImage('assets/images/person.png'),
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(height: 10.0,),
                        Text(name,
                            style: TextStyle(
                              color:Colors.black,
                              fontSize: 20.0,
                            )),
                        SizedBox(height: 10.0,),
                        Text('مشتري',
                          style: TextStyle(
                            color:Colors.black45,
                            fontSize: 15.0,
                          ),)
                      ]
                  ),
                ),
              ),

              Expanded(
                flex:5,
                child: Container(
                  color: Colors.grey[200],
                  child: Center(
                      child:Card(
                          margin: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                          child: Container()
                      )
                  ),
                ),
              ),

            ],
          ),
          Positioned(
              top:MediaQuery.of(context).size.height*0.38,
              left: 20.0,
              right: 20.0,

              child: Card(
                  child: Padding(
                    padding:EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            child:Column(
                              children: [
                                Text('قيد التجهيز',
                                  style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14.0
                                  ),),
                                SizedBox(height: 5.0,),
                                Text("$total_loading",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),)
                              ],
                            )
                        ),

                        Container(
                          child: Column(
                              children: [
                                Text('قيد التوصيل',
                                  style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14.0
                                  ),),
                                SizedBox(height: 5.0,),
                                Text('${total_driver}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),)
                              ]),
                        ),

                        Container(
                            child:Column(
                              children: [
                                Text('تم التوصيل',
                                  style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14.0
                                  ),),
                                SizedBox(height: 5.0,),
                                Text('${total_done}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),)
                              ],
                            )
                        ),
                      ],
                    ),
                  )
              )
          ),

            (items.isEmpty)?  ListView.builder(
              padding: EdgeInsets.only(top: size.height / 2),
            itemCount: 5, // عدد المرات التي ترغب في تكرار العنصر
            itemBuilder: (context, index) {
              return ShimmerPro.generated(
                light: shimmerlight,
                scaffoldBackgroundColor: bgColor,
                child: Row(
                  children: [
                    ShimmerPro.sized(
                      light: shimmerlight,
                      scaffoldBackgroundColor: bgColor,
                      height: size.width / 8,
                      width: size.width / 6,
                      borderRadius: 50,
                    ),
                    ShimmerPro.text(
                      light: shimmerlight,
                      scaffoldBackgroundColor: Colors.grey,
                      width: size.width / 2,
                    )
                  ],
                ),
              );
            },
          )
              :   ListView.builder(
              padding: EdgeInsets.only(top: size.height / 2),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Text(item["code"]),
                  title: Text(item["stat"]),
                  subtitle: Text('المبلغ الكلي: ${item["total"]}'),
                  trailing: Text('${item["date"]} '),
                );
              },
            ),





        ],

      ),
    );
  }
}