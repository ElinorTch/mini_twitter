import 'package:flutter/material.dart';
import 'package:mini_twitter/domain/providers/post_provider.dart';
import 'package:mini_twitter/features/posts/widgets/post_card.dart';
import 'package:mini_twitter/data/models/post_model.dart';
import 'package:mini_twitter/data/models/user_model.dart';
import 'package:mini_twitter/domain/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MyPostPage extends StatelessWidget {
  final List<PostModel> posts;
  final UserModel? userInfo;
  final UserProvider _userProvider = UserProvider();

  MyPostPage({super.key, required this.posts, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    final post_provider = context.watch<PostProvider>();

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
          user: userInfo ?? _userProvider.currentUser!,
          postProvider: post_provider,
        );
      },
    );
  }
}
