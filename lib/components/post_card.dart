import 'package:flutter/material.dart';
import 'package:mini_twitter/models/post.dart';
import 'package:mini_twitter/models/user.dart';

class PostCard extends StatelessWidget {
  // final UserModel user;
  // final PostModel post;

  const PostCard({
    super.key,
    // required this.user,
    // required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: 
                  // user.photoUrl != null 
                    // ? NetworkImage(user.photoUrl!)
                    AssetImage('assets/images/user.png'),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Pseudo", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('2h ago', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ]
                )
              ],
            ),
            SizedBox(height: 8),
            Text("lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
            // if (post.imageUrl != null) ...[
            //   SizedBox(height: 8),
            //   Image.network(post.imageUrl!),
            // ],
            // SizedBox(height: 8),
            // Text('Likes: ${post.likes}'),
          ],
        ),
      )
    );
  }
}