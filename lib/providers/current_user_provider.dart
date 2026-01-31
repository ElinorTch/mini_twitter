import 'package:flutter/material.dart';
import 'package:mini_twitter/models/user.dart';
import 'package:mini_twitter/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUserProvider extends ChangeNotifier {
  final UserService _userService = UserService();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  CurrentUserProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final firebaseUser = await _userService.getCurrentUser();

      if (firebaseUser == null) {
        _currentUser = null;
        notifyListeners();
        return;
      }

      _currentUser = await _userService.getUserById(firebaseUser.uid);
    } catch (e) {
      print("Error loading current user: $e");
    }

    notifyListeners();
  }

  Future<void> refreshUser() async {
    await _loadUser();
  }
}