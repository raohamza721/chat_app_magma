import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_shalk/controllers/chats_controllers.dart';
import 'package:talk_shalk/screens/setting.dart';
import 'package:talk_shalk/screens/user_profile.dart';
import 'chats_screen.dart';

class BottomNavBarScreen extends StatelessWidget {
  final ChatsController chatsController = Get.put(ChatsController());

  BottomNavBarScreen({super.key,});
  final List<Widget> navScreens = [
    Chats(),
    const Updates(),
    const SettingsScreen (),
    const UserProfile (),
  ];


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],


      body: Obx(() => IndexedStack(
          index: chatsController.selectedIndex.value,
          children: navScreens,
        ),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update_outlined),
            label: 'Updates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            label: 'Profile',
          ),
        ],
        currentIndex: chatsController.selectedIndex.value,
        selectedItemColor: Colors.green[500],
        unselectedItemColor: Colors.grey,
        onTap: chatsController.onItemSelect,
        backgroundColor: Colors.grey[100],
      )),
    );
  }


}

class Updates extends StatelessWidget {
  const Updates({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,

        title: const Text('Updates',style: TextStyle(color: Colors.white),),
      ),
    );
  }
}







