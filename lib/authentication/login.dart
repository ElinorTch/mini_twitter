import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_twitter/components/form_labeled_input.dart';
import 'package:mini_twitter/authentication/google_auth.dart';
import 'package:mini_twitter/authentication/registration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscure = true;
  bool _isLoading = false;
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  void setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Color(0xFFF6F7F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                  color: Color(0xFF617589),
                ),
              ),

              const SizedBox(height: 40),

              Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    LabeledFormInput(
                      label: 'Email', 
                      hint: 'Enter your email', 
                      controller: emailController, 
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    LabeledFormInput(
                      label: 'Password', 
                      hint: 'Enter your password', 
                      controller: passwordController, 
                      obscure: _obscure,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a password';
                        }
                        return null;
                      },
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
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    print("Forgot password pressed");
                  },
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: Color(0xFF137FEC),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_loginFormKey.currentState!.validate()) {
                    handleLogin(
                      context: context, 
                      formKey: _loginFormKey, 
                      firebaseAuth: FirebaseAuth.instance, 
                      email: emailController.text, 
                      password: passwordController.text, 
                      isLoading: _isLoading, 
                      setLoading: setLoading
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF137FEC),
                  minimumSize: const Size.fromHeight(60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
              ),

              const SizedBox(height: 20),

              Divider(
                height: 40,
                thickness: 1,
                color: Color(0xFFD1D5DB),
              ),

              const SizedBox(height: 20),

              GoogleAuthButton(),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Color(0xFF617589),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationPage()),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color(0xFF137FEC),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ), 

              const SizedBox(height: 20),
            ],
          ),
        ),
      )
    );
  }
}

Future<void> handleLogin({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required FirebaseAuth firebaseAuth,
  required String email,
  required String password,
  required bool isLoading,
  required void Function(bool) setLoading,
}) async {
  if (isLoading) return;

  String message = '';
  if (formKey.currentState!.validate()) {
    setLoading(true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        message = 'Invalid login credentials.';
      } else {
        message = e.code;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: $message')),
      );
      setLoading(false);
    } finally {
      // setLoading(false);
    }
  }
}