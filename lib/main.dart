import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/Bindings/Billing_bindings.dart';
import 'package:ecommerce/Bindings/Checkout_bindings.dart';
import 'package:ecommerce/Bindings/ItemBilling_bindings.dart';
import 'package:ecommerce/Bindings/RecentlyProducts_bindings.dart';
import 'package:ecommerce/Bindings/Cart_bindings.dart';
import 'package:ecommerce/Bindings/Category_bindings.dart';
import 'package:ecommerce/Bindings/Home_bindings.dart';
import 'package:ecommerce/Bindings/Landing_bindings.dart';
import 'package:ecommerce/Bindings/Product_bindings.dart';
import 'package:ecommerce/Bindings/Products_bindings.dart';
import 'package:ecommerce/controllers/Favorite_controller.dart';
import 'package:ecommerce/locale/Locale_controller.dart';
import 'package:ecommerce/locale/locale.dart';
import 'package:ecommerce/models/CartModel.dart';
import 'package:ecommerce/models/FavoriteModel.dart';
import 'package:ecommerce/views/Billing.dart';
import 'package:ecommerce/views/Checkout.dart';
import 'package:ecommerce/views/Favorites.dart';
import 'package:ecommerce/views/Item_Billing.dart';
import 'package:ecommerce/views/RecentlyProducts.dart';
import 'package:ecommerce/views/Cart.dart';
import 'package:ecommerce/views/Categories.dart';
import 'package:ecommerce/views/Home.dart';
import 'package:ecommerce/views/Landing.dart';
import 'package:ecommerce/views/Login.dart';
import 'package:ecommerce/views/ProductPage.dart';
import 'package:ecommerce/views/Products.dart';
import 'package:ecommerce/views/RegisterView.dart';
import 'controllers/Cart_controller.dart';
import 'package:intl/intl.dart';

SharedPreferences? sharedPreferences;
var formatter = NumberFormat("#,###");
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  Hive.registerAdapter(CartModelAdapter());
  Hive.registerAdapter(FavoriteModelAdapter());
  BoxCart = await Hive.openBox<CartModel>('BoxCart');
  BoxFavorite = await Hive.openBox<FavoriteModel>('Favorite');
  await Future.delayed(const Duration(milliseconds: 300));
  runApp(MyApp());
}

Locale_controller locale_controller = Get.put(Locale_controller());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else {
          return GetMaterialApp(
            translations: locale(),
            locale: locale_controller.inliaLang,
            title: '0'.tr,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              fontFamily: 'Tajawal',
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            initialRoute: '/',
            initialBinding: Landing_bindings(),
            getPages: [
              GetPage(
                name: '/',
                page: () => Login(),
                binding: Landing_bindings(),
                middlewares: [AuthMiddleware()],
              ),
              GetPage(
                  name: '/product',
                  page: () => ProductPage(),
                  binding: Product_bindings()),
              GetPage(
                  name: '/landing',
                  page: () => Landing(),
                  binding: Landing_bindings()),
              GetPage(
                  name: '/home', page: () => Home(), binding: Home_Bindings()),
              GetPage(
                  name: '/bestProducts',
                  page: () => RecentlyProducts(),
                  binding: RecentlyProducts_bindings()),
              GetPage(
                  name: '/cart',
                  page: () => CartPage(),
                  binding: Cart_bindings()),
              GetPage(
                  name: '/categories',
                  page: () => Categories(),
                  binding: Category_bindings()),
              GetPage(
                  name: '/products',
                  page: () => Products(),
                  binding: Products_bindings()),
              GetPage(
                  name: '/checkout',
                  page: () => Checkout(),
                  binding: Checkout_bindings()),
              GetPage(
                  name: '/favorites',
                  page: () => Favorites(),
                  binding: Checkout_bindings()),
              GetPage(
                  name: '/billing',
                  page: () => Billing(),
                  binding: Billing_bindings()),
              GetPage(
                  name: '/Item_Billing',
                  page: () => Item_Billing(),
                  binding: ItemBilling_bindings()),
              GetPage(
                  name: '/register',
                  page: () => RegisterView(),
                  binding: Landing_bindings()),
            ],
          );
        }
      },
    );
  }

  Future<void> _initializeApp() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (sharedPreferences?.getBool('remember') == true) {
      return RouteSettings(name: '/landing');
    }
    return null;
  }
}
