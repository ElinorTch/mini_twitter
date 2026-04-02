import 'package:flutter/material.dart';
import 'package:mini_twitter/domain/providers/post_provider.dart';
import 'package:mini_twitter/features/posts/widgets/post_card.dart';
import 'package:mini_twitter/data/models/post_model.dart';
import 'package:mini_twitter/domain/providers/user_provider.dart';
import 'package:provider/provider.dart';

class FollowingFeedPage extends StatefulWidget {
  const FollowingFeedPage({super.key});

  @override
  State<FollowingFeedPage> createState() => _FollowingFeedPageState();
}

class _FollowingFeedPageState extends State<FollowingFeedPage> {
  List<PostModel> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      final user = context.read<UserProvider>().currentUser;
      if (user != null) {
        context.read<PostProvider>().loadFollowing(user, refresh: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final feed = context.watch<PostProvider>();
    final user = context.watch<UserProvider>().currentUser;

    if (user == null || feed.isLoadingFollowing && !feed.hasLoadedFollowing) {
      return const Center(child: CircularProgressIndicator());
    }

    final posts = feed.followingPosts;

    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Aucun post à afficher"),
            TextButton(
              onPressed: () => feed.loadFollowing(user, refresh: true),
              child: const Text("Réessayer"),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => feed.loadFollowing(user, refresh: true),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final postUser = feed.getUserFromCache(post.userId);

          if (postUser == null) return const SizedBox();

          return PostCard(post: post, user: postUser, postProvider: feed);
        },
      ),
    );
  }
}
