
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/chats_controllers.dart';
import 'friends_screen.dart';
import 'inbox_screen.dart';

class chats extends StatelessWidget {
   chats({super.key});
  final ChatsController chatsController = Get.put(ChatsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: (chatsController.selectedIndex.value == 1 || chatsController.selectedIndex.value == 2
          || chatsController.selectedIndex.value == 3) ? null : AppBar(
        backgroundColor: Colors.green[500],
        title: const Text("Chats", style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => chatsController.signOut(),
          ),
        ],
      ),

      drawer: Drawer(
        child: Container(
          color: Colors.grey[850],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[700]!, Colors.green[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/icons/splashlogo.png'),
                    ),
                    SizedBox(height: 10),
                    Text('Chat App', style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _drawerTile(Icons.person_add, 'Friends', onTap: () => Get.to(const FriendsScreen())),
              _drawerTile(Icons.chat, 'Chats'),
              _drawerTile(Icons.settings, 'Settings'),
              _drawerTile(Icons.logout, 'Logout', onTap: chatsController.signOut),
            ],
          ),
        ),
      ),

      body:  Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/icons/imagechats.png',
              fit: BoxFit.cover,
            ),
          ),
          // Positioned.fill(
          //   child: Container(
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         colors: [Colors.grey.withOpacity(0.3), Colors.transparent],
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //       ),
          //     ),
          //   ),
          // ),
          Obx(() {
            if (chatsController.chats.isEmpty) {
              return const Center(
                child: Text(
                  "No active chats",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              );
            }
            return ListView.builder(
              itemCount: chatsController.chats.length,
              itemBuilder: (context, index) {
                var chatData = chatsController.chats[index].data() as Map<String, dynamic>;
                String chatId = chatData['chatId'];
                String lastMessage = chatData['lastMessage'];
                String user1Id = chatData['user1Id'];
                String user2Id = chatData['user2Id'];
                String currentUserId = chatsController.currentUser!.uid;
                String otherUserName = chatData['otherUserName'].toString();
                String otherPhotoUrl = chatData['otherUserPhotoUrl'].toString();
                String otherUserId = currentUserId == user1Id ? user2Id : user1Id;

                Timestamp lastMessageTimestamp = chatData['lastMessageTime'] as Timestamp;
                DateTime lastMessageTime = lastMessageTimestamp.toDate();
                String formattedTime = DateFormat('h:mm a').format(lastMessageTime);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  child: Card(
                    elevation: 6,
                    shadowColor: Colors.black.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.white.withOpacity(0.9),
                    child: ListTile(
                      tileColor: Colors.greenAccent[50],
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          otherPhotoUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        otherUserName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        lastMessage,
                        style: const TextStyle(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(formattedTime, style: TextStyle(
                        color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        Get.to(ChatScreen(
                          otherUserId: otherUserId,
                          otherUserName: otherUserName,
                          otherPhotoUrl: otherPhotoUrl,
                        ));
                      },
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(const FriendsScreen()),
        backgroundColor: Colors.green[500],
        elevation: 8,
        child: const Icon(Icons.person_add_sharp, color: Colors.white),
      ),
    ));



  }
   ListTile _drawerTile(IconData icon, String title, {VoidCallback? onTap}) {
     return ListTile(
       leading: Icon(icon, color: Colors.white),
       title: Text(
         title,
         style: const TextStyle(color: Colors.white, fontSize: 16),
       ),
       onTap: onTap,
       tileColor: Colors.black,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(10),
       ),
     );
   }
}