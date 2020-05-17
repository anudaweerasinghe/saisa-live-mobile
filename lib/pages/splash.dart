import 'dart:async';
import 'package:flutter/material.dart';
import 'package:saisa_live_app/pages/scores_home.dart';
import 'package:saisa_live_app/pages/follow_home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {

    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (ctxt) => new FollowScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
          child: new SizedBox(
            child: Container(
              child:Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child:new Image.asset('images/logo_transparent.png'),

              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    new Color.fromARGB(255, 20, 136, 204),
                    new Color.fromARGB(255, 43, 51, 178)
                  ],
                ),
              ),
            ),
            width: double.infinity,
            height: double.infinity,
          )

      ),
    );
  }
}