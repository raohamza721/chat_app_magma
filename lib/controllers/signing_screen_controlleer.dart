import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/bottomNavScreen.dart';
import '../screens/login_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Rxn<User> firebaseUser = Rxn<User>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      // Get Google authentication tokens
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      User? user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'displayName': user.displayName,
          'email': user.email,
          'photoURL': user.photoURL,
          'about': '',
        }, SetOptions(merge: true));
      }

      Get.to(() => BottomNavBarScreen());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();

    Get.offAll(() => LoginScreen());
  }
}
