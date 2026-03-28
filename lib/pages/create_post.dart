import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_twitter/main.dart';
import 'package:mini_twitter/models/post.dart';
import 'package:mini_twitter/providers/current_user_provider.dart';
import 'package:mini_twitter/services/image_service.dart';
import 'package:mini_twitter/services/post_service.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();
  final PostService _postService = PostService();
  final ImageService _imageService = ImageService();
  String? imageFilePath;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CurrentUserProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      // 1. La barre du haut (AppBar)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "New Post",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Couleur du bouton Publish
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                PostModel post = PostModel(
                  userId: provider.currentUser!.uid,
                  text: _textController.text,
                );

                String postId = await _postService.createPosts(post);
                _postService.uploadPostPhoto(postId, imageFilePath);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              },
              child: const Text(
                "Publish",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: provider.currentUser?.photoUrl != null
                      ? NetworkImage(provider.currentUser!.photoUrl!)
                      : AssetImage('assets/images/user.png') as ImageProvider,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.currentUser!.pseudo,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Public",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            if (imageFilePath != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(imageFilePath!),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          imageFilePath = null;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
                ),
              ),
            ),

            const Divider(),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.blue),
                  onPressed: () async {
                    XFile? image = await _imageService.pickImageFromGallery();
                    if (image != null) {
                      setState(() {
                        imageFilePath = image.path;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.alternate_email, color: Colors.grey),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.tag, color: Colors.grey),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(
                    Icons.sentiment_satisfied_alt,
                    color: Colors.grey,
                  ),
                  onPressed: () {},
                ),
                const Spacer(),
                const Text("0/280", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
