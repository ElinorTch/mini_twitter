import 'package:flutter/material.dart';
import 'package:mini_twitter/data/models/post_model.dart';
import 'package:mini_twitter/data/models/user_model.dart';
import 'package:mini_twitter/data/services/post_service.dart';
import 'package:mini_twitter/data/services/user_service.dart';

class FollowingFeedProvider extends ChangeNotifier {
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  List<PostModel> posts = [];
  bool isLoading = false;
  bool _hasLoadedOnce = false;
  bool get hasLoadedOnce => _hasLoadedOnce;

  UserModel? getUserFromCache(String userId) {
    return _userService.usersCache[userId];
  }

  void toggleLike(PostModel post, String userId) async {
    final isLiked = post.likes.contains(userId);

    if (isLiked) {
      post.likes.remove(userId);
      await _postService.unlikePost(post.uid!, userId);
    } else {
      post.likes.add(userId);
      await _postService.likePost(post.uid!, userId);
    }

    notifyListeners();
  }

  Future<void> loadPosts(UserModel user, {bool isRefresh = false}) async {
    if (!isRefresh && _hasLoadedOnce) return;

    isLoading = true;
    if (isRefresh) notifyListeners();

    try {
      final following = user.following;
      final fetchedPosts = await _postService.getFollowingPosts(following);

      await Future.wait(
        fetchedPosts.map((post) => _userService.getUser(post.userId)),
      );

      posts = fetchedPosts;
      isLoading = false;
      _hasLoadedOnce = true;
    } catch (e) {
      debugPrint("Erreur refresh: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
