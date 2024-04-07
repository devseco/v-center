import 'dart:convert';
import 'package:ecommerce/Pages/Cats.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer_pro/shimmer_pro.dart';
import '../api/connect.dart';
List items = [];
bool loading = true;
class BrandsPage extends StatefulWidget {
  const BrandsPage({super.key});

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}
late Color  bgColor = Colors.grey;
late ShimmerProLight shimmerlight = ShimmerProLight.darker;
class _BrandsPageState extends State<BrandsPage> {
  Future<void> get_Items() async {
    var url = Uri.parse(Apis.Api + 'brands.php');
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
    return  Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      appBar: AppBar(
        title: Text('البراندات'),
        centerTitle: true,
      ),
      body:  (items.isEmpty)?  GridView.builder(
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
      )
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // عدد العناصر في كل صف
          crossAxisSpacing: 10, // المسافة الأفقية بين العناصر
          mainAxisSpacing: 10, // المسافة الرأسية بين العناصر
          childAspectRatio: 1.0, // نسبة أبعاد العناصر
        ),
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Cats(brand:  items[index]["title"],)),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80, // تحديد العرض المطلوب للصورة
                    height: 80, // تحديد الارتفاع المطلوب للصورة
                    child: Image.network(
                      items[index]["image"],
                      fit: BoxFit.cover, // لتناسب الصورة مع الحاوية
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    items[index]["title"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16, // حجم النص
                    ),
                  ),
                ],
              ),
            ),
          );

        },
      ),
    ));
  }
}



