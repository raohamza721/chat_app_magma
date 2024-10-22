import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_shalk/controllers/friends_controller.dart';
import 'inbox_screen.dart';

 class FriendsScreen extends StatelessWidget {
  final FriendsController chatsController = Get.put(FriendsController());

   FriendsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Friends'),
      ),
      body: Obx(() {
        if (chatsController.users.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: chatsController.users.length,
          itemBuilder: (context, index) {
            var user = chatsController.users[index];
            if (user['uid'] == chatsController.currentUser?.uid) {
              return Container();
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.cyan,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['photoURL']),
                  ),
                  title: Text(user['displayName']),
                  subtitle: Text(user['email']),
                  onTap: () {
                    Get.to(() => ChatScreen(otherUserId: user['uid'], otherUserName: user['displayName'], otherPhotoUrl: user['photoURL'], ));
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

