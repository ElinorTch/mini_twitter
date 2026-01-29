import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthButton extends StatelessWidget {
  const GoogleAuthButton({super.key});

  Future<dynamic> signInWithGoogle(
      BuildContext context
  ) async {
    try {
      GoogleSignIn.instance.initialize(serverClientId: '599906860098-oqskkgvgcu762lom827aneenjbdmvinr.apps.googleusercontent.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();

      if (googleUser == null) {
        print("Google sign in aborted");
        return;
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      return await FirebaseAuth.instance.signInWithCredential(credential);
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