import 'package:flutter/material.dart';
import 'package:mini_twitter/domain/providers/post_provider.dart';
import 'package:mini_twitter/features/posts/widgets/post_card.dart';
import 'package:mini_twitter/data/models/post_model.dart';
import 'package:mini_twitter/data/models/user_model.dart';
import 'package:provider/provider.dart';
// import 'package:mini_twitter/domain/providers/current_user_provider.dart';

class LikedPostPage extends StatelessWidget {
  final List<PostModel> likedPosts;
  final UserModel? userInfo;
  // final CurrentUserProvider currentUserProvider = CurrentUserProvider();

  LikedPostPage({super.key, required this.likedPosts, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    final feed = context.watch<PostProvider>();

    if (likedPosts.isEmpty) {
      return const Center(
        child: Text("No liked posts yet", style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: likedPosts.length,
      itemBuilder: (context, index) {
        final post = likedPosts[index];

        return PostCard(post: post, user: userInfo!, postProvider: feed);
      },
    );
  }
}
