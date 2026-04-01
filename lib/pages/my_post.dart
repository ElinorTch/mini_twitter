import 'package:flutter/material.dart';
import 'package:mini_twitter/components/post_card.dart';
import 'package:mini_twitter/data/models/post_model.dart';
import 'package:mini_twitter/data/models/user_model.dart';
import 'package:mini_twitter/domain/providers/current_user_provider.dart';

class MyPostPage extends StatelessWidget {
  final List<PostModel> posts;
  final UserModel? userInfo;
  final CurrentUserProvider currentUserProvider = CurrentUserProvider();

  MyPostPage({super.key, required this.posts, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Center(
        child: Text("No posts yet", style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];

        return PostCard(
          post: post,
          user: userInfo ?? currentUserProvider.currentUser!,
        );
      },
    );
  }
}
