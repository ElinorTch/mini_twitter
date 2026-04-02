import 'package:flutter/material.dart';
import 'package:mini_twitter/domain/providers/for_you_feed_provider.dart';
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
    // Future.microtask(() {
    //   if (mounted) context.read<ForYouFeedProvider>().loadAllPosts();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final feed = context.watch<ForYouFeedProvider>();

    if (feed.isLoading && !feed.hasLoadedOnce) {
      return const Center(child: CircularProgressIndicator());
    }

    if (feed.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Aucun post à afficher"),
            TextButton(
              onPressed: () => feed.loadAllPosts(isRefresh: true),
              child: const Text("Réessayer"),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => feed.loadAllPosts(isRefresh: true),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: feed.posts.length,
        itemBuilder: (context, index) {
          final post = feed.posts[index];
          final author = feed.getUserFromCache(post.userId);

          if (author == null) return const SizedBox();
          return PostCard(post: post, user: author);
        },
      ),
    );
  }
}
