import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talk_shalk/screens/login_screen.dart';

class FriendsController extends GetxController {
  var users = <QueryDocumentSnapshot>[].obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() {
    FirebaseFirestore.instance.collection('users').snapshots().listen((snapshot) {
      users.value = snapshot.docs;
    });
  }


  User? get currentUser => _auth.currentUser;

  void signOut() async {
    await _auth.signOut();
    Get.offAll(LoginScreen());
  }
}
