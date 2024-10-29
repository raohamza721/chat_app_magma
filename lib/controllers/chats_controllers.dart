import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/login_screen.dart';

class ChatsController extends GetxController {
  var chats = <QueryDocumentSnapshot>[].obs;  // Observable for active chats
  final FirebaseAuth _auth = FirebaseAuth.instance;



  @override
  void onInit() {
    super.onInit();
    fetchActiveChats();
  }

  // Fetch chats where the current user is either user1Id or user2Id
  void fetchActiveChats() {
    String currentUserId = _auth.currentUser!.uid;

    FirebaseFirestore.instance.collection('chats').where('user1Id', isEqualTo: currentUserId).snapshots()
        .listen((snapshot) {
      chats.value = snapshot.docs;
    });

    FirebaseFirestore.instance.collection('chats').where('user2Id', isEqualTo: currentUserId)
        .snapshots()
        .listen((snapshot) {
      chats.addAll(snapshot.docs);
    });
  }

  User? get currentUser => _auth.currentUser;

  void signOut() async {
    await _auth.signOut();
    Get.offAll(LoginScreen());

  }

  final selectedIndex = 0.obs;

  void onItemSelect(int index){
     selectedIndex.value = index;
  }
}
