import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shimmer_pro/shimmer_pro.dart';

import '../api/connect.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}
List items = [];
bool loading = true;
class _CartPageState extends State<CartPage> {

  late Color  bgColor = Colors.grey;
  late ShimmerProLight shimmerlight = ShimmerProLight.darker;
   int total = 0;
  int get totalPrice => items.fold(0, (sum, item) => (sum + (int.parse(item["price"]) * int.parse( item["count"]))) as int);
  String formattedTotalPrice(price) {
    final formatter = NumberFormat('#,###', 'ar_IQ');
    return formatter.format(price);
  }
  Future<void> get_Items() async {
    print(2);
    var url = Uri.parse(Apis.Api + 'carts.php?id=2');

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
    print(1);

  }
   void didChangeDependencies() {
     super.didChangeDependencies();
     get_Items();
     print(1);
     // اكتب هنا الكود الخاص بتحميل البيانات
   }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    items.clear();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('سلة المشتريات'),
      ),
      body: Column(
        children: [
          (items.isEmpty)?  Expanded(child: ListView.builder(
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
          ))
              :  Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Dismissible(
                  key: Key(item["id"]), // يجب أن يكون المفتاح فريدًا لكل عنصر
                  direction: DismissDirection.endToStart, // السحب من اليمين إلى اليسار
                  onDismissed: (direction) {
                    delete(item["id"]);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  child: ListTile(
                    leading: Image.network(item["image"], width: 50, height: 50),
                    title: Text(item["title"]),
                    subtitle: Text('الكمية: ${item["count"]}'),
                    trailing: Text('${formattedTotalPrice(int.parse(item["price"]))}  د.ع '),
                  ),
                );
              },
            ),

          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الأجمالي : ${formattedTotalPrice(totalPrice)} د.ع ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    QuickAlert.show(

                      title: "تأكيد الشراء",
                      context: context,
                      type: QuickAlertType.confirm,
                      text: 'هل انت متأكد من اكمال الشراء',
                      confirmBtnText: 'تاكيد',
                      cancelBtnText: 'الغاء',
                      confirmBtnColor: Colors.green,
                      onConfirmBtnTap:(){
                        Done('2','07712710192','alshaab','Ali Mohammed',totalPrice.toString());
                      },
                    );
                  },
                  child: Text('إتمام الشراء'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
   void delete(String id) async {
     var url1 = Uri.parse(
         Apis.Api + 'delete_cart.php?id=' + id
     );
     http.Response response = await http.get(url1);
     if (response.body.toString().contains("successfully")) {
       setState(() {
         int index = items.indexWhere((item) => item["id"] == id); // العثور على موقع العنصر باستخدام الـ ID
         if (index != -1) {
           items.removeAt(index); // حذف العنصر إذا وجد
           total = totalPrice; // إعادة حساب المبلغ الكلي
         } // حذف العنصر من القائمة
       });
       // عرض رسالة تأكيد الحذف (اختياري)
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text("تم الحذف بنجاح"),
           duration: Duration(seconds: 2),
         ),
       );
     }
   }
  void Done(String user , phone , address , username , total) async {
    var url1 = Uri.parse(
        Apis.Api + 'add_bill.php?user=' + user + '&phone=' + phone + '&address=' + address + '&username=' + username + '&total=' + total
    );
    http.Response response = await http.get(url1);
    print(response.body);
    if (response.body.toString().contains("Successfully")) {
      setState(() {
        Navigator.pop(context);
        get_Items();
      });
    }
  }

}
