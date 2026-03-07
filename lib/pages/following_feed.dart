import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_twitter/components/post_card.dart';
import 'package:mini_twitter/models/post.dart';
import 'package:mini_twitter/models/user.dart';
import 'package:mini_twitter/providers/current_user_provider.dart';
import 'package:mini_twitter/services/post_service.dart';
import 'package:mini_twitter/services/user_service.dart';

class FollowingFeed extends StatefulWidget {
  const FollowingFeed({super.key});

  @override
  State<FollowingFeed> createState() => _FollowingFeedState();
}

class _FollowingFeedState extends State<FollowingFeed> {
  final currentUser = CurrentUserProvider();
  final PostService postService = PostService();
  final UserService userService = UserService();

  List<PostModel> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    final following = currentUser.currentUser?.following ?? [];

    print("User is following: ${currentUser.currentUser}");

    final fetchedPosts = await postService.getMyPosts(currentUser.currentUser!.uid);

    // for (final post in fetchedPosts) {
    //   await userService.getUser(post.userId);
    // }

    setState(() {
      posts = fetchedPosts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (posts.isEmpty) {
      return IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          loadPosts();
        },
      );
// const Center(child: Text("Aucun post pour le moment"));
    }

    return RefreshIndicator(
      onRefresh: loadPosts,
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final user = userService.usersCache[post.userId]!;

          return PostCard(
            post: post,
            user: user,
          );
        },
      ),
    );
  }
}