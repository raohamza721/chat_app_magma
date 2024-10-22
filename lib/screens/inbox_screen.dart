import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_shalk/controllers/inbox_controller.dart';

class ChatScreen extends StatelessWidget {
  final String otherUserId;
  final String otherUserName;
  final String otherPhotoUrl;

  final InboxController chatController = Get.put(InboxController());

  ChatScreen({super.key, required this.otherUserId, required this.otherUserName, required this.otherPhotoUrl,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Chat with $otherUserName'),
      ),
      body: Column(
        children: [
          Expanded(
            // StreamBuilder to listen for chat messages
            child: StreamBuilder(
              stream: chatController.getMessages(otherUserId),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    bool isSender = message['senderId'] == chatController.authController.firebaseUser.value!.uid;

                    return Align(
                      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: isSender ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text( message['text'], style: TextStyle(
                              color: isSender ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  // TextField for message input
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: chatController.messageController,
                      decoration: const InputDecoration(
                          hintText: 'Enter message',
                          border: OutlineInputBorder()),

                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => chatController.sendMessage(otherUserId, otherUserName, otherPhotoUrl,),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
