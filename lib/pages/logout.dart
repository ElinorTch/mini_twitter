import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_twitter/auth_gate.dart';
import 'package:mini_twitter/pages/login.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        try {
          await FirebaseAuth.instance.signOut();
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => const AuthGate(),
              ), 
              (route) => false,
            );
          });
        } on Exception catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to logout: $e')),
          );
        }
      },
      icon: const Icon(Icons.logout),
    );
  }
}