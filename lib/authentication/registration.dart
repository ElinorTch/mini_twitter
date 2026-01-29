import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_twitter/components/form_labeled_input.dart';
import 'package:mini_twitter/main.dart';
import 'package:mini_twitter/authentication/login.dart';
import 'package:mini_twitter/services/user_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _obscure = true;
  bool _isLoading = false;

  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();
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
              const SizedBox(height: 10),

              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Join our community today.',
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

                    const SizedBox(height: 20),

                    LabeledFormInput(
                      label: 'Confirm password', 
                      hint: 'Confirm your password', 
                      controller: confirmPasswordController, 
                      obscure: _obscure,
                      validator: (value) {
                        if (value == null || value.isEmpty || value != passwordController.text) {
                          return 'Your password doesn\'t match';
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
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_loginFormKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    handleFirebaseRegistration(
                      context: context,
                      formKey: _loginFormKey,
                      firebaseAuth: FirebaseAuth.instance,
                      email: emailController.text,
                      password: passwordController.text,
                      isLoading: _isLoading,
                      setLoading: setLoading,
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
                      'Sign Up',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Color(0xFF617589),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Sign In",
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


Future<void> handleFirebaseRegistration({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required FirebaseAuth firebaseAuth,
  required String email,
  required String password,
  required bool isLoading,
  required void Function(bool) setLoading,
}) async {
  if (isLoading) return;

  UserService userService = UserService();

  String message = 'Configuration error. Please try again.';

  if (formKey.currentState!.validate()) {
    setLoading(true);

    try {
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = userCredential.user;

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

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ), 
          (route) => false,
        );
      });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register: $e')),
      );
    } finally {
      setLoading(false);
    }
  }
}