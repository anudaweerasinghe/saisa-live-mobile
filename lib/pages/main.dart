import 'package:flutter/material.dart';
import 'package:saisa_live_app/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new HomeScreen(),
      theme: ThemeData(fontFamily: 'Roboto'),

    );
  }
}