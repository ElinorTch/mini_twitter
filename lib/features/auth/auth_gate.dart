import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_twitter/main.dart';
import 'package:mini_twitter/features/auth/login_page.dart';
import 'package:mini_twitter/domain/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

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

        // Utilisateur connecté
        if (snapshot.hasData) {
          final firebaseUser = snapshot.data!;
          final userProvider = context.watch<UserProvider>();

          if (userProvider.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (userProvider.currentUser != null) {
            return const HomePage();
          }

          return const Scaffold(
            body: Center(child: Text("Chargement du profil...")),
          );
        }

        // Utilisateur non connecté
        return const LoginPage();
      },
    );
  }
}

// class AuthGate extends StatelessWidget {
//   final UserProvider currentUser = UserProvider();

//   AuthGate({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (snapshot.hasData) {
//           return const HomePage();
//         }

//         return const LoginPage();
//       },
//     );
//   }
// }
