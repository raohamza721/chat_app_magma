import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';












class SettingsScreen extends StatelessWidget  {
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: Text('SETTING',style: TextStyle(color: Colors.white),),
      ),
      body: Center(child: Text('Setting')),
    );
  }
  const SettingsScreen({super.key});
}

