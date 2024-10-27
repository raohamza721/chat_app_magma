import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talk_shalk/controllers/signing_screen_controlleer.dart';

class InboxController extends GetxController {
  final AuthController authController = Get.put(AuthController());
  final messageController = TextEditingController();

  String getChatId(String otherUserId) {
    String currentUserId = authController.firebaseUser.value!.uid;
    return currentUserId.hashCode <= otherUserId.hashCode
        ? '$currentUserId-$otherUserId'
        : '$otherUserId-$currentUserId';
  }

  // Send a text message
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
        'otherUserName': otherUserName,
        'otherUserPhotoUrl': otherPhotoUrl,
      });

      FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').add({
        'text': message,
        'senderId': authController.firebaseUser.value!.uid,
        'timestamp': DateTime.now(),
      });

      messageController.clear();
    }
  }

  // Send an image message
  Future<void> sendImageMessage(String otherUserId, String otherUserName, String otherPhotoUrl) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String filePath = 'chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg';

      try {
        UploadTask uploadTask = FirebaseStorage.instance.ref(filePath).putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();

        String chatId = getChatId(otherUserId);
        FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').add({
          'imageUrl': imageUrl,
          'senderId': authController.firebaseUser.value!.uid,
          'timestamp': DateTime.now(),
        });

        FirebaseFirestore.instance.collection('chats').doc(chatId).update({
          'lastMessage': '[Image]',
          'lastMessageTime': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }

  // Stream to get messages
  Stream<QuerySnapshot> getMessages(String otherUserId) {
    return FirebaseFirestore.instance.collection('chats').doc(getChatId(otherUserId))
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
