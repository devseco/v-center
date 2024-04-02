import 'package:flutter/material.dart';
import 'Brands.dart';
import 'Cart.dart';
import 'MainHome.dart';
import 'Profile.dart';
import 'package:fancy_bottom_navigation_plus/fancy_bottom_navigation_plus.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

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
        body: _pages[_currentIndex],
        bottomNavigationBar: FancyBottomNavigationPlus(
          barBackgroundColor: Color(0xfffbb448),
          barheight: MediaQuery.of(context).size.height * 0.10,
          titleStyle: TextStyle(color: Colors.black),
          tabs: [
            TabData(
              icon: const Icon(Icons.home, color: Colors.white, size: 35),
              title: "الرئيسية",
            ),
            TabData(
              icon: const Icon(Icons.list, color: Colors.white, size: 35),
              title: "الشركات",
            ),
            TabData(
              icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 35),
              title: "سلة المشتريات",
            ),
            TabData(
              icon: const Icon(Icons.person, color: Colors.white, size: 35),
              title: "الملف الشخصي",
            ),
          ],
          initialSelection: _currentIndex,
          onTabChangedListener: (int position) {
            setState(() {
              _currentIndex = position;
            });
          },
        ),
      ),
    );
  }
}
