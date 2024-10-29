import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var users = <QueryDocumentSnapshot>[].obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() {
    FirebaseFirestore.instance.collection('users').snapshots().listen((
        snapshot) {
      users.value = snapshot.docs;
    });
  }

  User? get currentUser => _auth.currentUser;

  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? email,
    String? about,
    String? photoUrl,
  }) async {
    try {
      Map<String, dynamic> updatedData = {};

      if (name != null) updatedData['displayName'] = name;
      if (email != null) updatedData['email'] = email;
      if (about != null) updatedData['about'] = about;
      if (photoUrl != null) updatedData['photoURL'] = photoUrl;

      await FirebaseFirestore.instance.collection('users').doc(userId).update(updatedData);
      Get.snackbar("Success", "Profile updated successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile: $e");
    }
  }



}
