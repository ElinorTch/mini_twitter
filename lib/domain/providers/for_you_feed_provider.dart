import 'package:flutter/material.dart';
import 'package:mini_twitter/data/models/post_model.dart';
import 'package:mini_twitter/data/models/user_model.dart';
import 'package:mini_twitter/data/services/post_service.dart';
import 'package:mini_twitter/data/services/user_service.dart';

class ForYouFeedProvider extends ChangeNotifier {
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  List<PostModel> posts = [];
  bool isLoading = false;
  bool hasLoadedOnce = false;

  // Récupère l'utilisateur depuis le cache global du UserService
  UserModel? getUserFromCache(String userId) => _userService.usersCache[userId];

  Future<void> loadAllPosts(UserModel user, {bool isRefresh = false}) async {
    if (!isRefresh && hasLoadedOnce) return;
    if (isLoading) return;

    isLoading = true;
    if (isRefresh) notifyListeners();

    try {
      // 1. Récupérer TOUS les posts (ajoute cette méthode dans ton PostService)
      final fetchedPosts = await _postService.getAllPosts(user);

      // 2. Remplir le cache des auteurs pour éviter les "null" dans l'UI
      await Future.wait(
        fetchedPosts.map((post) => _userService.getUser(post.userId)),
      );

      posts = fetchedPosts;
      hasLoadedOnce = true;
    } catch (e) {
      debugPrint("Erreur For You Feed: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
