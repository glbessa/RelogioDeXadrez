import 'package:flutter/material.dart';
import 'main_page.dart';

// criacao de widgets estaticos
class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
      '/':(context) => MainPage()
      }
    );
  }
}