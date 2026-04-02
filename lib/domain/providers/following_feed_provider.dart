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

  bool userCacheIsEmpty() {
    return _userService.usersCache.isEmpty;
  }

  Future<void> loadPosts(UserModel user, {bool isRefresh = false}) async {
    print(user.email);
    print(userCacheIsEmpty());
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
