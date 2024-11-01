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
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/images/icons/imagechats.png',
              fit: BoxFit.cover,
            ),
          ),
          // Main Chat UI
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.green[500],
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(otherPhotoUrl),
                      radius: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(otherUserName, style: const TextStyle(color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                actions: [
                  
                  PopupMenuButton(itemBuilder: (context)=> [
                    PopupMenuItem(
                      value: 1,
                        child: Row(
                      children: [
                        const Icon(Icons.block),
                        Text(chatController.isUserBlocked.value ? 'Unblock user' : 'Block user'),                      ],
                    )),
                    const PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.clear),
                            Text('clear chat')
                          ],
                        )),
                  ],

                    elevation: 2,
                    onSelected: (value){
                    if(value == 1){
                      chatController.toggleBlockUser(otherUserId);
                    }
                    },
                  ),
                ],
              ),
              Expanded(
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
                        String? messageText = message.data().containsKey('text') ? message['text'] : null;
                        String? imageUrl = message.data().containsKey('imageUrl') ? message['imageUrl'] : null;

                        return Align(
                          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: isSender ? Colors.green : Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(isSender ? 12 : 0),
                                topRight: Radius.circular(isSender ? 0 : 12),
                                bottomLeft: const Radius.circular(12),
                                bottomRight: const Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: messageText != null ? Text(messageText, style: TextStyle(
                              color: isSender ? Colors.white : Colors.black,
                              fontSize: 16,),) : (imageUrl != null ? Image.network(imageUrl, width: 150, fit: BoxFit.cover,
                            ) : const SizedBox.shrink()),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Obx(() => Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: chatController.isUserBlocked.value
                    ? const Center(
                  child: Text('User is blocked',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
                    : Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image, color: Colors.green),
                      onPressed: () => chatController.sendImageMessage(otherUserId, otherUserName, otherPhotoUrl),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: chatController.messageController,
                          decoration: const InputDecoration(
                            hintText: 'Enter message',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 24,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () => chatController.sendMessage(otherUserId, otherUserName, otherPhotoUrl),
                      ),
                    ),
                  ],
                ),
              )),

            ],
          ),
        ],
      ),
    );
  }
  
}
