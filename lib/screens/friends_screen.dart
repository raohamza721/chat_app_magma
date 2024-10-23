import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_shalk/controllers/friends_controller.dart';
import 'inbox_screen.dart';

class FriendsScreen extends StatefulWidget {
  FriendsScreen({super.key});

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final FriendsController chatsController = Get.put(FriendsController());
  TextEditingController searchController = TextEditingController();
  var searchQuery = ''.obs; // Observable for search input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){},
          
          icon: const Icon(Icons.arrow_back_rounded,color: Colors.white,) ),
        
        backgroundColor: Colors.black,
        title: const Text('Friends',style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: Container(

        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  label: const Text('Search Friends',style: TextStyle(
                    color: Colors.white
                  ),),
                  prefixIcon: const Icon(Icons.search,color: Colors.white,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onChanged: (value) {
                  searchQuery.value = value; // Update search query
                },
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (chatsController.users.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Filter users based on search query
                var filteredUsers = chatsController.users.where((user) {
                  var displayName = user['displayName']?.toLowerCase() ?? '';
                  return displayName.contains(searchQuery.value.toLowerCase());
                }).toList();

                if (filteredUsers.isEmpty) {
                  return const Center(child: Text('No friends found'));
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      var user = filteredUsers[index];
                      if (user['uid'] == chatsController.currentUser?.uid) {
                        return Container();
                      }

                      return Card(
                        color: Colors.black,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user['photoURL']),
                          ),
                          title: Text(user['displayName'],style: const TextStyle(color: Colors.white),),
                          subtitle: Text(user['email'],style: const TextStyle(color: Colors.white),),
                          onTap: () {
                            Get.to(() => ChatScreen(
                              otherUserId: user['uid'],
                              otherUserName: user['displayName'],
                              otherPhotoUrl: user['photoURL'],
                            ));
                          },
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
