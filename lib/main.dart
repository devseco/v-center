import 'package:ecommerce/Pages/Home.dart';
import 'package:ecommerce/Pages/map.dart';
import 'package:ecommerce/src/loginPage.dart';
import 'package:ecommerce/src/welcomePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       fontFamily: "bein",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  MapScreen(),
    );
  }
}

