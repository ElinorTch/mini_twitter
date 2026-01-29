import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mini_twitter/services/user_service.dart';

class GoogleAuthButton extends StatelessWidget {
  const GoogleAuthButton({super.key});

  Future<dynamic> signInWithGoogle(
      BuildContext context
  ) async {
    UserService userService = UserService();

    try {
      GoogleSignIn.instance.initialize(serverClientId: '599906860098-oqskkgvgcu762lom827aneenjbdmvinr.apps.googleusercontent.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();

      if (googleUser == null) {
        print("Google sign in aborted");
        return;
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      
      if (user != null) {
        final bool exists = await userService.pseudoExists(user.email!.split('@')[0]);
        if (!exists) {
          await userService.createUser(
            user.uid,
            user.email!,
            user.email!.split('@')[0],
          );
        }
      }
    } catch (e) {
      print("Error caught: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFFFFFF),
        minimumSize: const Size.fromHeight(60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () => signInWithGoogle(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logos/google.png',
            height: 22,
            width: 22,
          ),
          SizedBox(width: 5),
          Text(
            'Google', 
            style: TextStyle(
              color: Color(0xFF000000),
              fontWeight: FontWeight.bold,
            )
          ),
        ],
      ),
    );
  }
}