import 'package:flutter/material.dart';
import 'package:foodorder/Screen/LoginScreen/Login.dart';
import 'package:foodorder/controller/auth.dart';
import 'package:get/get.dart';

void main() {
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Authentication authController = Get.put(Authentication());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'JAMOTO',
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
