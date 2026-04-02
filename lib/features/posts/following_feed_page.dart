import 'package:flutter/material.dart';
import 'package:mini_twitter/domain/providers/following_feed_provider.dart';
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

    // Future.microtask(() {
    //   if (!mounted) return;

    //   final user = context.read<UserProvider>().currentUser;

    //   if (user != null) {
    //     context.read<FollowingFeedProvider>().loadPosts(user, isRefresh: true);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final feed = context.watch<FollowingFeedProvider>();
    final user = context.watch<UserProvider>().currentUser;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!feed.hasLoadedOnce && feed.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (feed.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Aucun post à afficher"),
            TextButton(
              onPressed: () => feed.loadPosts(user, isRefresh: true),
              child: const Text("Réessayer"),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => feed.loadPosts(user, isRefresh: true),
      child: ListView.builder(
        // Physics indispensable pour que le scroll fonctionne même si la liste est courte
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: feed.posts.length,
        itemBuilder: (context, index) {
          final post = feed.posts[index];
          final postUser = feed.getUserFromCache(post.userId);

          if (postUser == null) return const SizedBox();
          return PostCard(post: post, user: postUser);
        },
      ),
    );
  }
}
