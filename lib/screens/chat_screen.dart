import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_shalk/controllers/chats_controllers.dart';
import 'package:talk_shalk/screens/friends_screen.dart';
import 'inbox_screen.dart';
import 'package:intl/intl.dart';

class ChatsScreen extends StatelessWidget {
  final ChatsController chatsController = Get.put(ChatsController());

   ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Chats",style: TextStyle(
          color: Colors.white ,
        ),),
        actions: [
          IconButton(
            icon: const Icon(Icons.search,color: Colors.white,),
            onPressed: () => chatsController.signOut(),
          ),
          // IconButton(
          //   icon: const Icon(Icons.person_add_sharp),
          //   onPressed: () => Get.to(const FriendsScreen()),
          // ),
        ],
      ),
      drawer: Drawer(

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(

            children: const [
              // DrawerHeader(child: Image.asset('assets/images/icons/splashlogo.png'))
              ListTile(
                tileColor: Colors.black,
                leading: Icon(Icons.person_add,color: Colors.white,),
                title: Text('Friends',style: TextStyle(
                  color: Colors.white
                ),),
              ),
              const SizedBox(height: 5 ),
              ListTile(
                tileColor: Colors.black,
                leading: Icon(Icons.chat,
                  color: Colors.white,
                ),
                title: Text('Chats',
                  style: TextStyle(
                  color: Colors.white,)
                  ,),
              ),
              const SizedBox(height: 5 ),

              ListTile(
                tileColor: Colors.black,
                leading: Icon(Icons.settings,
                  color: Colors.white,
                ),
                title: Text('SETTING',  style: TextStyle(
                  color: Colors.white,)),
              ),
              const SizedBox(height: 5 ),

              ListTile(
                tileColor: Colors.black,

                leading: Icon(Icons.logout,
                  color: Colors.white,
                ),
                title: Text('LOGOUT',  style: TextStyle(
                  color: Colors.white,)),
              )
            ],
          ),
        ),
      ),
      
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            Image.asset(
              fit: BoxFit.fitHeight,
                'assets/images/icons/imagechats.png'),
            Obx(() {
              if (chatsController.chats.isEmpty) {
                return const Center(child: Text("No active chats"));
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

                  // Convert Firestore timestamp to DateTime
                  Timestamp lastMessageTimestamp = chatData['lastMessageTime'] as Timestamp;
                  DateTime lastMessageTime = lastMessageTimestamp.toDate();

                  String formattedTime = DateFormat('h:mm a').format(lastMessageTime);

                  return ListTile(
                    tileColor: Colors.greenAccent[50],
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(otherPhotoUrl)),
                    title: Text(otherUserName),
                    subtitle: Text(lastMessage,style: TextStyle(
                        color: Colors.grey
                    ),),
                    trailing: Text(formattedTime,style: TextStyle(
                        color: Colors.grey[400]
                    ),),

                    onTap: () {
                      Get.to(ChatScreen(otherUserId: otherUserId, otherUserName: otherUserName, otherPhotoUrl: otherPhotoUrl ));
                    },
                  );
                },
              );
            }),
          ]

        ),
      ),



      floatingActionButton: FloatingActionButton  (onPressed: () => Get.to(const FriendsScreen()),
          backgroundColor: Colors.green,
          child: const Icon(Icons.person_add_sharp,color: Colors.black,)),
    );
  }
}
