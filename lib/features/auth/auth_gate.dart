import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_twitter/main.dart';
import 'package:mini_twitter/features/auth/login_page.dart';
import 'package:mini_twitter/domain/providers/current_user_provider.dart';

class AuthGate extends StatelessWidget {
  final CurrentUserProvider currentUser = CurrentUserProvider();

  AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomePage();
        }

        return const LoginPage();
      },
    );
  }
}
