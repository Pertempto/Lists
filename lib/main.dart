import 'package:flutter/material.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/view/home_page.dart';

void main() async {
  await DatabaseManager.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff7f8266)),
      ),
      home: const HomePage(),
    );
  }
}
