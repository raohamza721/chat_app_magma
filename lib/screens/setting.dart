import 'package:flutter/material.dart';



class SettingsScreen extends StatelessWidget  {
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        title: const Text('SETTING',style: TextStyle(color: Colors.white),),
      ),
      body: const Center(child: Text('Setting')),
    );
  }
  const SettingsScreen({super.key});
}

