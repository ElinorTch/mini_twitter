import 'package:flutter/material.dart';
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
    return Container(
      child: Container(),
    );
  }
}