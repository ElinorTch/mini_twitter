import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_twitter/services/user_service.dart';

class ProfilePage extends StatefulWidget {
  final String? userId; 

  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {

  UserService userService = UserService();
  late User? userInfo;

  Future<void> _loadUserInfo() async {
    final currentUser = await userService.getCurrentUser();

    final userInfo = widget.userId == null
        ? currentUser
        : await userService.getUserById(widget.userId!);

    setState(() {
      this.userInfo = userInfo;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            color: Colors.grey, 
            height: 0.5,          
          ),
        ),

        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // your action here
            },
          ),
        ],
      ),
      body: Center(
        child: Text('User Profile Page'),
      ),
    );
  }
}