import 'package:flutter/material.dart';
import 'package:mini_twitter/components/post_card.dart';

class FollowingFeed extends StatelessWidget {
  const FollowingFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            PostCard(),
            SizedBox(height: 16),
            PostCard(),
          ],
        ),
      ),
    );
  }
}