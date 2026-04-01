import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_twitter/models/user.dart';
import 'package:mini_twitter/data/services/user_service.dart';

class CurrentUserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  UserModel? _currentUser;
  bool _isLoading = true;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  CurrentUserProvider() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      _isLoading = true;
      notifyListeners();

      if (firebaseUser == null) {
        _currentUser = null;
      } else {
        _currentUser = await _userService.getUserById(firebaseUser.uid);
      }

      _isLoading = false;
      notifyListeners();
    });
  }
}
