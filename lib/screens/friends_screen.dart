import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talk_shalk/controllers/friends_controller.dart';
import 'inbox_screen.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final FriendsController chatsController = Get.put(FriendsController());
  TextEditingController searchController = TextEditingController();
  var searchQuery = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
        backgroundColor: Colors.green[600],
        title: const Text('Friends', style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Search Friends',
                  labelStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                onChanged: (value) {
                  searchQuery.value = value;
                },
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (chatsController.users.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                }

                var filteredUsers = chatsController.users.where((user) {
                  var displayName = user['displayName']?.toLowerCase() ?? '';
                  return displayName.contains(searchQuery.value.toLowerCase());
                }).toList();

                if (filteredUsers.isEmpty) {
                  return const Center(
                    child: Text('No friends found',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
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
                        color: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(user['photoURL']),
                            backgroundColor: Colors.green[100],
                          ),
                          title: Text(user['displayName'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            user['email'],
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
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
