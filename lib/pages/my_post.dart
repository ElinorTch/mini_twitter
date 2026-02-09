import 'package:flutter/material.dart';

class MyPostPage extends StatelessWidget {
  const MyPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Posts"),
      ),
      body: const Center(
        child: Text("This is the My Posts page."),
      ),
    );
  }
}