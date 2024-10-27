import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:talk_shalk/controllers/signing_screen_controlleer.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset('assets/images/icons/imagechats.png', fit: BoxFit.cover,),
          ),
          Center(child: Container(width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9), // White background with some transparency
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset('assets/images/icons/splashlogo.png'),
                    ),
                    const SizedBox(height: 20),
                    const Text('Welcome Back!', style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Change to black for better contrast
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text('Please sign in to continue', style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Obx(() {
                      if (authController.isLoading.value) {
                        return const CircularProgressIndicator(color: Colors.black,);
                      } else {
                        return ElevatedButton(style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            elevation: 10,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            shadowColor: Colors.redAccent.withOpacity(0.5),
                          ),
                          onPressed: () {authController.signInWithGoogle();},
                          child: const Row(mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text('Sign in with Google', style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // Navigate to email login screen
                      }, child: const Text('Sign in with Email',
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
