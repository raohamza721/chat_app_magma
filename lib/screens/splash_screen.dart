import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_shalk/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override


  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(LoginScreen());  // Navigates to HomeScreen and clears the stack
    });


    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 120, width: 120,
      child: Image.asset('assets/images/icons/splashlogo.png')),
          const SizedBox(height: 10,),
          const Text('Talk Shalk',style: TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),)
        ],
      )),

    );
  }
}
