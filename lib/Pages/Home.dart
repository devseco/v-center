import 'package:aqua_nav_bar/aqua_nav_bar.dart';
import 'package:ecommerce/Pages/Sales.dart';
import 'package:ecommerce/src/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'Brands.dart';
import 'Cart.dart';
import 'MainHome.dart';
import 'Profile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  int currentIndex = 0;
  final List<Widget> _pages = [
    const MainHome(),
    const BrandsPage(),
    CartPage(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("V-Center"),
              Image.asset('assets/images/logo.png' , fit: BoxFit.fill,height: 40,width: 40,),
            ],
          ),
          backgroundColor: Colors.transparent,
          leading: Padding(padding: EdgeInsets.only(right: 20,top: 15),
            child: GestureDetector(
              onTap: (){
                launchWhatsAppUri();
              },
              child: FaIcon(FontAwesomeIcons.whatsapp , color: Colors.black,),
            ),
          ),
          actions: [
            Padding(padding: EdgeInsets.only(left: 10,top: 10),
              child: GestureDetector(
                onTap: (){
                  logout();
                },
                child: Icon(Icons.logout ,color: Colors.black ),
              ),
            ),
          ],
        ),
        body: _pages[currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 5.0,
              ),
            ],
          ),
          child: AquaNavBar(
            currentIndex: currentIndex,
            textSize: 14.0,
            backgroundColor: Colors.transparent,
            activeColor: Colors.black,
            textColor: Colors.black,
            onItemSelected: (index){
              setState(() {
                currentIndex = index;
              });
            },
            barItems: [
              BarItem(
                  title: "الرئيسية",

                  icon: const Icon(
                    Icons.home_outlined,
                    size: 30.0,
                    color: Colors.black,
                  )),
              BarItem(
                  title: "الفئات",
                  icon: const Icon(
                    Icons.category_outlined,
                    size: 30.0,
                  )),
              BarItem(
                  title: "السلة",
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    size: 30.0,
                  )),
              BarItem(
                  title: "الملف الشخصي",
                  icon: const Icon(
                    Icons.person_outlined,
                    size: 30.0,
                  )),
            ], ),
        ),
      ),
    );
  }
  void logout() async{
    print(1);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }
  launchWhatsAppUri() async {
    final link = const WhatsAppUnilink(
      phoneNumber: '+9647752855594',
      text: "Hey! I'm inquiring about the apartment listing",
    );
    // Convert the WhatsAppUnilink instance to a Uri.
    // The "launch" method is part of "url_launcher".
    await launch(link.asUri() as String);
  }
}
