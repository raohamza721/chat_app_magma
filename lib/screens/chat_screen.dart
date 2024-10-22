import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_shalk/controllers/chats_controllers.dart';
import 'package:talk_shalk/screens/friends_screen.dart';
import 'inbox_screen.dart';

class ChatsScreen extends StatelessWidget {
  final ChatsController chatsController = Get.put(ChatsController());

   ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => chatsController.signOut(),
          ),
          IconButton(
            icon: const Icon(Icons.person_add_sharp),
            onPressed: () => Get.to(FriendsScreen()),
          ),
        ],
      ),
      body: Obx(() {
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

            return ListTile(
              leading: Image.network(otherPhotoUrl),
              title: Text(otherUserName),
              subtitle: Text(lastMessage),
              
              onTap: () {
                Get.to(ChatScreen(otherUserId: otherUserId, otherUserName: otherUserName, otherPhotoUrl: otherPhotoUrl ));
              },
            );
          },
        );
      }),
    );
  }
}
