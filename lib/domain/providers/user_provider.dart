import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_twitter/data/models/user_model.dart';
import 'package:mini_twitter/data/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  UserModel? _currentUser;
  bool _isLoading = true;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  void toggleFollow(UserModel targetUser) async {
    final current = currentUser!;
    final isFollowing = current.following.contains(targetUser.uid);

    if (isFollowing) {
      current.following.remove(targetUser.uid);
      notifyListeners();
      await _userService.unfollowUser(current.uid, targetUser.uid);
    } else {
      current.following.add(targetUser.uid);
      notifyListeners();
      await _userService.followUser(current.uid, targetUser.uid);
    }
  }

  UserProvider() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      _isLoading = true;
      notifyListeners();

      if (firebaseUser == null) {
        _currentUser = null;
      } else {
        _currentUser = await _userService.getUserById(firebaseUser.uid);

        _isLoading = false;
        notifyListeners();
      }
    });
  }
}
