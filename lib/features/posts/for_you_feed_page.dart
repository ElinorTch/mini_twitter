import 'package:flutter/material.dart';
import 'package:mini_twitter/domain/providers/post_provider.dart';
import 'package:mini_twitter/domain/providers/user_provider.dart';
import 'package:mini_twitter/features/posts/widgets/post_card.dart';
import 'package:provider/provider.dart';

class ForYouFeedPage extends StatefulWidget {
  const ForYouFeedPage({super.key});

  @override
  State<ForYouFeedPage> createState() => _ForYouFeedPageState();
}

class _ForYouFeedPageState extends State<ForYouFeedPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      final user = context.read<UserProvider>().currentUser;
      if (user != null) {
        context.read<PostProvider>().loadForYou(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final feed = context.watch<PostProvider>();
    final user = context.watch<UserProvider>().currentUser;

    if (user == null) return const Center(child: CircularProgressIndicator());

    if (feed.isLoadingForYou && !feed.hasLoadedForYou) {
      return const Center(child: CircularProgressIndicator());
    }

    final posts = feed.forYouPosts;

    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Aucun post à afficher"),
            TextButton(
              onPressed: () => feed.loadForYou(user, refresh: true),
              child: const Text("Réessayer"),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => feed.loadForYou(user, refresh: true),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          final author = feed.getUserFromCache(post.userId);

          if (author == null) return const SizedBox();

          return PostCard(post: post, user: author, postProvider: feed);
        },
      ),
    );
  }
}
