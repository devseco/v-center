import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as innt;
import 'package:shimmer_pro/shimmer_pro.dart';
import 'package:http/http.dart' as http;
import '../api/connect.dart';
class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}
String id = "";
late SharedPreferences prefs;
late Color  bgColor = Colors.grey;
late ShimmerProLight shimmerlight = ShimmerProLight.darker;
String formattedTotalPrice(price) {
  final formatter = innt.NumberFormat('#,###', 'ar_IQ');
  return formatter.format(price);
}
List items = [];
String total_done = "0";
String total_driver = "0";
String total_loading = "0";
bool loading = true;
class _SalesState extends State<Sales> {
  Future<void> get_Items(String idd) async {
    var url = Uri.parse(Apis.Api + 'bills.php?id='+ idd +'&limit=300');
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ()async{
      prefs = await SharedPreferences.getInstance();
      id = prefs.getString("id")!;
      get_Items(id);
    }();

  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Directionality(textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text("المشتريات"),
            backgroundColor: Color(0xfffbb448),

          ),
          body: Column(
            children: [
              Card(
                color: Color(0xfffbb448),
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
                                      color: Colors.black,
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
                                      color: Colors.black,
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
                                      color: Colors.black,
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
              ),
              (items.isEmpty)?  Expanded(child: ListView.builder(
                itemCount: 10, // عدد المرات التي ترغب في تكرار العنصر
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
              ))
              
                  :   Expanded(child: ListView.builder(
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
              ),)
            ],
          ),
        ));
  }
}
