import 'package:flutter/material.dart';
import 'package:mini_twitter/helpers/date_helper.dart';
import 'package:mini_twitter/models/post.dart';
import 'package:mini_twitter/models/user.dart';

class PostCard extends StatelessWidget {
  final UserModel user;
  final PostModel post;

  const PostCard({
    super.key,
    required this.user,
    required this.post,
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
                  backgroundColor: Color(0xFFf6f7f8),
                  backgroundImage: user.photoUrl != null
                    ? NetworkImage(user.photoUrl!)
                    : null,
                  child: user.photoUrl == null
                    ? Image.asset('assets/images/person.png')
                    : null,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.pseudo, style: TextStyle(color: Color(0xFF111418), fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(timeAgo(post.createdAt), style: TextStyle(color: Color(0xFF617589), fontSize: 12)),
                  ]
                )
              ],
            ),
            if (post.imageUrl != null) ...[
              SizedBox(height: 8),
              Image.network(post.imageUrl!),
            ],
            SizedBox(height: 8),
            Text(
              post.text,
              style: TextStyle(color: Color(0xFF111418), fontWeight: FontWeight.w500),
            ),
            
            SizedBox(height: 8),
            Divider(thickness: 0.5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        print("Icon clicked");
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Icon(Icons.favorite, size: 20, color: Color(0xFF617589)),
                            SizedBox(width: 2),
                            Text('10'),
                          ],
                        )
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        print("Icon clicked");
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Icon(Icons.comment, size: 20, color: Color(0xFF617589)),
                            SizedBox(width: 2),
                            Text('10'),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                IconButton(
                  iconSize: 20,
                  icon: Icon(Icons.share),
                  color: Color(0xFF617589),
                  onPressed: () {
                    print("Icon clicked");
                  },
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}