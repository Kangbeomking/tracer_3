import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Advanced Todo List App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      home: MainPage(),
    );
  }
}
