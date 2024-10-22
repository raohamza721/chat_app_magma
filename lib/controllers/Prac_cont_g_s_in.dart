// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';


// class AuthController extends GetxController{
//
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//
//   Rxn<User> user = Rxn<User>();
//
//
//   Future<void> signInWithGoogle() async {
//     try{
//
//       final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
//
//       if(googleUser== null){
//
//         return;
//       }
//
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       final  credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//       await auth.signInWithCredential(credential);
//
//       User? user  = auth.currentUser;
//
//       if(user != null ){
//         FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//
//           "uid": user.uid,
//           'email': user.email,
//           'displayName': user.displayName,
//           'PhotoURL' : user.photoURL,
//
//         });
//
//       }
//
//     }catch(e){
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }
//
// }




// // fetch users
//
// class FetchUsers extends GetxController{
//   var user = <QueryDocumentSnapshot>[].obs;
//
//   Future<void> getUsers()async {
//
//     FirebaseFirestore.instance.collection('users').snapshots().listen((snapshot) {
//       user.value = snapshot.docs;
//     });
//   }
// }