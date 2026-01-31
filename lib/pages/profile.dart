import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_twitter/components/button.dart';
import 'package:mini_twitter/components/follow_card.dart';
import 'package:mini_twitter/models/user.dart';
import 'package:mini_twitter/providers/current_user_provider.dart';
import 'package:mini_twitter/services/user_service.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String? userId; 

  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {

  UserService userService = UserService();
  UserModel? userInfo;

  Future<void> _loadUserInfo(CurrentUserProvider provider) async {
    final currentUser = await userService.getCurrentUser();

    final userInfo = widget.userId == null
        ? provider.currentUser
        : await userService.getUserById(widget.userId!);

    setState(() {
      this.userInfo = userInfo;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CurrentUserProvider>();
    _loadUserInfo(provider);

    if (userInfo == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/user.png'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '@${userInfo!.pseudo}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${userInfo!.bio}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_month, size: 16, color: Colors.grey),
                SizedBox(width: 5),
                Text(
                  'Joined ${DateFormat('MMMM yyyy').format(userInfo!.joinedAt)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FollowCard(
                    title: '128',
                    subtitle: 'POSTS',
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: FollowCard(
                    title: userInfo!.following.length.toString(),
                    subtitle: 'FOLLOWING',
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: FollowCard(
                    title: userInfo!.followers.length.toString(),
                    subtitle: 'FOLLOWERS',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            PrimaryButton(label: 'Edit profile', isLoading: false, onPressed: () {}),
          ],
        ),
      )
    );
  }
}