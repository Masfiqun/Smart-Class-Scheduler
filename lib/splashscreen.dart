import 'dart:async';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:smart_class_scheduler/auth_screen.dart';
import 'package:smart_class_scheduler/homepage.dart';
import 'package:smart_class_scheduler/screens/login_screen.dart'; // Import GetWidget package

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.white, Colors.lightBlueAccent],
            radius: 2
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('asset/image/asl.png', width: 200, height: 200),
              SizedBox(height: 5),
              Text(
                'Creativity Starts with Beleif',
                style: TextStyle(
                  fontFamily: 'Eastwood',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              GFLoader(
                type: GFLoaderType.android,
                loaderColorOne: Colors.lightBlueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
