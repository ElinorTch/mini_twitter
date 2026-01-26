import 'package:flutter/material.dart';
import 'package:mini_twitter/components/labeled_input.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

   final bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[250],
      body: Padding(
        padding:  const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Login to stay connected with your community.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40),
            LabeledInput(
              label: 'Email',
              hint: 'Enter your email',
              controller: TextEditingController(),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            LabeledInput(
              label: 'Password',
              hint: 'Enter your password',
              obscure: _obscure,
              controller: TextEditingController(),
              keyboardType: TextInputType.text,
              iconButton: IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              ),
            ),
          ]
        ),
    ));
  }
}