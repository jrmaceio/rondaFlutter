import 'package:flutter/material.dart';
import 'package:ronda/home_page.dart';
import 'package:get/get.dart';
import 'package:ronda/rondas.dart';
import 'package:ronda/visitante.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/ronda', page: () => RondaPage()),
        GetPage(name: '/visitante', page: () => Visitante()),
      ],
    );
  }
}
