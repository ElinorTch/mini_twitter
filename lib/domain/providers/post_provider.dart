import 'package:flutter/material.dart';
import 'package:mini_twitter/data/models/post_model.dart';
import 'package:mini_twitter/data/models/user_model.dart';
import 'package:mini_twitter/data/services/post_service.dart';
import 'package:mini_twitter/data/services/user_service.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService = PostService();
  final UserService _userService = UserService();
  final Map<String, PostModel> postCache = {};

  List<PostModel> forYouPosts = [];
  List<PostModel> followingPosts = [];

  bool isLoadingForYou = false;
  bool isLoadingFollowing = false;

  bool hasLoadedForYou = false;
  bool hasLoadedFollowing = false;

  UserModel? getUserFromCache(String userId) {
    return _userService.usersCache[userId];
  }

  Future<void> toggleLike(PostModel post, UserModel currentUser) async {
    final userId = currentUser.uid;

    final cachedPost = postCache[post.uid]!;
    final isLiked = cachedPost.likes.contains(userId);

    if (isLiked) {
      cachedPost.likes.remove(userId);
      currentUser.likedPosts.remove(post.uid);
      notifyListeners();

      await _postService.unlikePost(post.uid!, userId);
      await _userService.removeLikedPost(userId, post.uid!);
    } else {
      cachedPost.likes.add(userId);
      currentUser.likedPosts.add(post.uid!);
      notifyListeners();

      await _postService.likePost(post.uid!, userId);
      await _userService.addLikedPost(userId, post.uid!);
    }
  }

  Future<void> loadFollowing(UserModel user, {bool refresh = false}) async {
    if (!refresh && hasLoadedFollowing) return;
    if (isLoadingFollowing) return;

    isLoadingFollowing = true;
    notifyListeners();

    try {
      final fetched = await _postService.getFollowingPosts(user.following);

      // Remplir le cache global
      for (final p in fetched) {
        postCache[p.uid!] = p;
      }

      // Charger les auteurs
      await Future.wait(fetched.map((p) => _userService.getUser(p.userId)));

      // Construire le feed à partir du cache
      followingPosts = fetched.map((p) => postCache[p.uid]!).toList();

      hasLoadedFollowing = true;
    } catch (e) {
      debugPrint("Erreur Following Feed: $e");
    } finally {
      isLoadingFollowing = false;
      notifyListeners();
    }
  }

  Future<void> loadForYou(UserModel user, {bool refresh = false}) async {
    if (!refresh && hasLoadedForYou) return;
    if (isLoadingForYou) return;

    isLoadingForYou = true;
    notifyListeners();

    try {
      final fetched = await _postService.getAllPosts(user);

      for (final p in fetched) {
        postCache[p.uid!] = p;
      }

      await Future.wait(fetched.map((p) => _userService.getUser(p.userId)));

      forYouPosts = fetched.map((p) => postCache[p.uid]!).toList();

      hasLoadedForYou = true;
    } catch (e) {
      debugPrint("Erreur For You Feed: $e");
    } finally {
      isLoadingForYou = false;
      notifyListeners();
    }
  }
}
