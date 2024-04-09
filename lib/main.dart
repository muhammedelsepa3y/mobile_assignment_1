import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_assignment_1/screens/login_screen.dart';
import 'package:mobile_assignment_1/services/desk_storage.dart';
import 'package:mobile_assignment_1/services/navigation_service.dart';
import 'package:provider/provider.dart';

void main()async {
  await Hive.initFlutter();
  runApp(MyApp());}
class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile App',
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(
        useMaterial3: true,
      ),
      builder: EasyLoading.init(),
      home: LoginScreen(),
    );
  }
}
