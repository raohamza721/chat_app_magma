import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_shalk/controllers/signing_screen_controlleer.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.green,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Center(
          child: Text('Login', style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.greenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Welcome Back!', style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 50),
            Obx(() {
              if (authController.isLoading.value) {
                return const CircularProgressIndicator(
                  color: Colors.white,
                );
              } else {
                return ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    authController.signInWithGoogle();
                  },
                  child: const Text('Sign in with Google',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
