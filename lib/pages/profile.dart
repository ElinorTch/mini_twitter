import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_twitter/components/button.dart';
import 'package:mini_twitter/components/follow_card.dart';
import 'package:mini_twitter/components/profile_info.dart';
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

  @override
  void initState() {
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CurrentUserProvider>();

    if (provider.currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
              ProfileHeader(user: provider.currentUser!),
              
              const SizedBox(height: 20),
              
              PrimaryButton(label: 'Edit profile', isLoading: false, onPressed: () {}),
              
              const SizedBox(height: 20),
              
              TabBar(
                labelColor: Color(0xFF137FEC),
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(text: 'Posts'),
                  Tab(text: 'Media'),
                  Tab(text: 'Likes'),
                ],
              ),

              SizedBox(
                height: 1000, 
                child: TabBarView(
                  children: [
                    Center(child: Text("Posts de l'utilisateur")),
                    Center(child: Text("Photos / vidéos")),
                    Center(child: Text("Posts likés")),
                  ],
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}