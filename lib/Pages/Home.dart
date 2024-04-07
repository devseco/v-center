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
          title: const Text("V-Center"),
          backgroundColor: const Color(0xfffbb448),
          actions: [
            Padding(padding: EdgeInsets.only(left: 20,top: 10),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Sales()),
                  );
                },
                child: FaIcon(FontAwesomeIcons.listCheck , color: Colors.black,),
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 20,top: 10),
              child: GestureDetector(
                onTap: (){
                  launchWhatsAppUri();
                },
                child: FaIcon(FontAwesomeIcons.whatsapp , color: Colors.black,),
              ),
            ),
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
        bottomNavigationBar: AquaNavBar(
          currentIndex: currentIndex,
          textSize: 15.0,
          backgroundColor: const Color(0xfffbb448),
          activeColor: Colors.white,
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
                  Icons.home,
                  size: 30.0,
                  color: Colors.black,
                )),
            BarItem(
                title: "الفئات",
                icon: const Icon(
                  Icons.list_alt,
                  size: 30.0,
                )),
            BarItem(
                title: "السلة",
                icon: const Icon(
                  Icons.shopping_cart,
                  size: 30.0,
                )),
            BarItem(
                title: "الملف الشخصي",
                icon: const Icon(
                  Icons.person,
                  size: 30.0,
                )),
          ], ),
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
