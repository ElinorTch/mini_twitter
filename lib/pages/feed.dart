import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: DefaultTabController(length: 2, 
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: 'For You'),
                  Tab(text: 'Following'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Center(child: Text('For You Feed, To come!!')),
                    Center(child: Text('Following Feed')),
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