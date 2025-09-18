import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ecommerce/controllers/Landing_controller.dart';
import 'package:ecommerce/controllers/Home_controller.dart';
import 'package:ecommerce/controllers/Cart_controller.dart';
import 'package:ecommerce/locale/Locale_controller.dart';
import 'package:ecommerce/views/Categories.dart';
import 'package:ecommerce/views/Home.dart';
import 'package:ecommerce/views/Profile.dart';
import 'package:ecommerce/views/Cart.dart';
import 'package:ecommerce/views/search_view.dart';
import 'package:ecommerce/main.dart';

class Landing extends StatelessWidget {
  Landing({super.key});
  final Landing_controller controller = Get.put(Landing_controller());
  final locale_controller = Get.put(Locale_controller());

  // تهيئة Home_controller
  final Home_controller homeController = Get.find<Home_controller>();
  static final List<Widget> _pages = <Widget>[
    Home(),
    Categories(),
    CartPage(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        key: controller.pagesViewScaffoldKey,
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          surfaceTintColor: Colors.deepPurple,
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepPurple.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          leadingWidth: Get.height * 0.12,
          leading: logo(),
          title: GestureDetector(
            onTap: () {
              Get.to(() => SearchView());
            },
            child: Container(
              height: Get.height * 0.045,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(width: Get.width * 0.04),
                  Icon(
                    Icons.search,
                    color: Colors.deepPurple,
                    size: Get.width * 0.06,
                  ),
                  SizedBox(width: Get.width * 0.02),
                  Text(
                    '9'.tr,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: Get.width * 0.035,
                    ),
                  ),
                ],
              ),
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            type: BottomNavigationBarType.fixed,
            selectedItemColor:
                Colors.deepPurple, // Change to your desired color
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              controller.onItemTapped(index);
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                label: '14'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.category_outlined),
                label: '15'.tr,
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    Icon(Icons.shopping_cart),
                    GetBuilder<Cart_controller>(
                      builder: (cartController) {
                        return BoxCart.length > 0
                            ? Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${BoxCart.length}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                            : SizedBox.shrink();
                      },
                    ),
                  ],
                ),
                label: "السلة",
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outlined),
                label: '17'.tr,
              ),
            ],
          ),
        ),
        body: GetBuilder<Landing_controller>(
          builder: (c) {
            return _pages.elementAt(c.selectedIndex.value);
          },
        ),
      ),
    );
  }

  SizedBox spaceH(double size) {
    return SizedBox(height: size);
  }

  SizedBox spaceW(double size) {
    return SizedBox(width: size);
  }

  GestureDetector logo() {
    return GestureDetector(
      onTap: () {
        final uri = Uri.tryParse('');
        if (uri != null) {
          // launchUrl(uri);
        }
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: Get.height * 0.01,
          top: Get.height * 0.01,
          bottom: Get.height * 0.01,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(Get.height * 0.003),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            width: Get.height * 0.035,
            height: Get.height * 0.020,
          ),
        ),
      ),
    );
  }
}
