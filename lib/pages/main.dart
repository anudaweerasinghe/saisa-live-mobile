import 'package:flutter/material.dart';
import 'package:saisa_live_app/pages/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new SplashScreen(),
      theme: ThemeData(fontFamily: 'Roboto'),

    );
  }
}