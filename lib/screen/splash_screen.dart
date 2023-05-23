import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ph_login/screen/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 2), (() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) {
        return Login();
      })));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(50),
        child: Center(
          child: Image.asset('assets/meetme.png'),
        ),
      ),
    );
  }
}
