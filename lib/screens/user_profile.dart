import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:talk_shalk/screens/profile_edit_screen.dart';
import '../controllers/profile_controller.dart';

class UserProfile extends StatefulWidget {
   const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final ProfileController chatsController = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
        backgroundColor: Colors.green[500],
        title: const Text("Profile", style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [IconButton(onPressed: (){
          Get.to(ProfileEditScreen());
        }, icon: const Icon(Icons.edit))]
      ),
      body:  Obx((){

        if(chatsController.users.isEmpty){
          return const CircularProgressIndicator();
        }

        var user = chatsController.users.first.data() as Map<String, dynamic>;

       return Column(


          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30,),
            (user.isEmpty)?
            const Center(
               child:   CircleAvatar(
                    radius: 80, child: Icon(Icons.person,size: 60,))) :
            InstaImageViewer(imageUrl: user['photoURL'],
              child: CircleAvatar(
               radius: 80, backgroundImage: NetworkImage(user['photoURL']),
              ),
            ),
            const SizedBox(height: 30,),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Name',style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12
              ),),
              subtitle: Text(user['displayName'],style: const TextStyle(
                  color: Colors.blueGrey
              ),),
            ),

             ListTile(
              leading: const Icon(Icons.abc_sharp),
              title: const Text('About',style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12
              ),),
              subtitle: Text(user['about'],style: const TextStyle(
                  color: Colors.blueGrey
              ),),
            ),

             ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email',style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12
              ),),
              subtitle: Text(user['email'],style: const TextStyle(
                  color: Colors.blueGrey
              ),),
            )
          ],
        );
      }
      ),
    );
  }
}