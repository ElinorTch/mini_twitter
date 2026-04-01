import 'package:flutter/material.dart';
import 'package:mini_twitter/components/post_card.dart';
import 'package:mini_twitter/data/models/post_model.dart';
import 'package:mini_twitter/data/models/user_model.dart';
import 'package:mini_twitter/domain/providers/current_user_provider.dart';
import 'package:mini_twitter/data/services/post_service.dart';
import 'package:mini_twitter/data/services/user_service.dart';
import 'package:provider/provider.dart';

class FollowingFeed extends StatefulWidget {
  const FollowingFeed({super.key});

  @override
  State<FollowingFeed> createState() => _FollowingFeedState();
}

class _FollowingFeedState extends State<FollowingFeed> {
  final PostService postService = PostService();
  final UserService userService = UserService();

  List<PostModel> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Future.microtask(() => loadPosts());
  }

  Future<void> loadPosts(UserModel user) async {
    // final provider = context.read<CurrentUserProvider>();
    // final following = provider.currentUser?.following ?? [];
    final following = user.following;

    print("User is following: ${following}");

    final fetchedPosts = await postService.getFollowingPosts(following);

    for (final post in fetchedPosts) {
      await userService.getUser(post.userId);
    }

    print("Les fetchposts $fetchedPosts");

    setState(() {
      // posts = [];
      posts = fetchedPosts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CurrentUserProvider>();

    if (provider.currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (posts.isEmpty) {
      return IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          loadPosts(provider.currentUser!);
        },
      );
    }

    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final user = userService.usersCache[post.userId]!;

        return PostCard(post: post, user: user);
      },
    );
  }
}
