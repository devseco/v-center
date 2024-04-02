import 'package:flutter/material.dart';
import 'package:sweet_nav_bar/sweet_nav_bar.dart';

import 'Brands.dart';
import 'Cart.dart';
import 'Cats.dart';
import 'MainHome.dart';
import 'Profile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MainHome(),
    BrandsPage(),
    CartPage(),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("V-Center"),
          backgroundColor:  Color(0xfffbb448),
        ),
        body: TabBarView(
          controller: _tabController,
          children: _pages,
        ),
        bottomNavigationBar: SweetNavBar(
          backgroundColor: const Color(0xfffbb448),
          currentIndex: _currentIndex,
          items: [
            SweetNavBarItem(
              sweetActive: const Icon(Icons.home, color: Colors.black),
              sweetIcon: const Icon(Icons.home, color: Colors.black45),
              sweetLabel: 'الرئيسية',
              sweetBackground: const Color(0xfffbb448),
            ),
            SweetNavBarItem(
              sweetActive: const Icon(Icons.list, color: Colors.black),
              sweetIcon: const Icon(Icons.list, color: Colors.black45),
              sweetLabel: 'العلامات التجارية',
              sweetBackground: const Color(0xfffbb448),
            ),
            SweetNavBarItem(
              sweetActive: const Icon(Icons.shopping_cart, color: Colors.black),
              sweetIcon: const Icon(Icons.shopping_cart, color: Colors.black45),
              sweetLabel: 'العربة',
              sweetBackground: const Color(0xfffbb448),
            ),
            SweetNavBarItem(
              sweetActive: const Icon(Icons.person, color: Colors.black),
              sweetIcon: const Icon(Icons.person, color: Colors.black45),
              sweetLabel: 'الملف الشخصي',
              sweetBackground: const Color(0xfffbb448),
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _tabController.animateTo(index); // تحديث المؤشر على العلامة تبعاً للصفحة المحددة
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
