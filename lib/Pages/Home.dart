import 'package:aqua_nav_bar/aqua_nav_bar.dart';
import 'package:flutter/material.dart';
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
}
