import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_shalk/controllers/profile_controller.dart';

class ProfileEditScreen extends StatelessWidget {
   ProfileEditScreen({super.key});

  ProfileController profileController = Get.put(ProfileController());


  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController aboutController = TextEditingController();
    String? profileImageUrl;


    var user = profileController.users.first.data() as Map<String, dynamic>;

    nameController.text = user["displayName"];
    profileImageUrl =user['photoURL'].toString();
    emailController.text = user['email'];
    aboutController.text = user['about'];




    void saveProfile() {
      if (formKey.currentState!.validate()) {
        profileController.updateUserProfile(
          userId: profileController.currentUser!.uid,
          name: nameController.text,
          email: emailController.text,
          about: aboutController.text,
          photoUrl: profileImageUrl,
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () async {
                  // Code to pick an image from gallery or camera
                  // Assign the selected image URL to profileImageUrl
                },
                child: CircleAvatar(radius: 80,
                  backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl)
                      : null,
                  child: profileImageUrl == null
                      ? const Icon(Icons.camera_alt, size: 50)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: aboutController,
                decoration: const InputDecoration(
                  labelText: 'About',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[500],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Save Changes',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

