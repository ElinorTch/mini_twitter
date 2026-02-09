import 'package:flutter/material.dart';
import 'package:mini_twitter/pages/following_feed.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf6f7f8),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Community Feed'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification button press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: DefaultTabController(length: 2, 
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: 'Following'),
                  Tab(text: 'For You'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Center(child: Text('Following Feed, to come!!')),
                    // FollowingFeed(),
                    Center(child: Text('For You Feed, To come!!')),
                    // Image.asset('assets/images/profile.png')
                  ],
                ),
              ),
            ],
          )
        )
      ),
    );
  }
}