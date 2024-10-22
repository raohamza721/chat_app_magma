import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:talk_shalk/controllers/signing_screen_controlleer.dart';

class InboxController extends GetxController {
  final AuthController authController = Get.put(AuthController());
  final messageController = TextEditingController(); // Controller for the message input


  // String getChatId(String otherUserId) {
  //   String currentUserId = authController.firebaseUser.value!.uid;
  //   return '$currentUserId-$otherUserId';
  // }
  String getChatId(String otherUserId) {
    String currentUserId = authController.firebaseUser.value!.uid;
    return currentUserId.hashCode <= otherUserId.hashCode ? '$currentUserId-$otherUserId' : '$otherUserId-$currentUserId';
  }


  void sendMessage(String otherUserId, String otherUserName, String otherPhotoUrl) {
    String message = messageController.text.trim();
    if (message.isNotEmpty) {
      String chatId = getChatId(otherUserId);
      FirebaseFirestore.instance.collection('chats').doc(chatId).set({
        'chatId': chatId,
        'user1Id': authController.firebaseUser.value!.uid,
        'user2Id': otherUserId,
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'otherUserName' : otherUserName,
        'otherUserPhotoUrl': otherPhotoUrl
      });

      FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').add({
        'text': message,
        'senderId': authController.firebaseUser.value!.uid,
        'timestamp': DateTime.now(),
      });

      messageController.clear(); // Clear the input field after sending
    }
  }

  Stream<QuerySnapshot> getMessages(String otherUserId) {
    return FirebaseFirestore.instance.collection('chats').doc(getChatId(otherUserId))
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
