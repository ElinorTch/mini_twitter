import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_twitter/models/post.dart';
import 'package:mini_twitter/services/image_service.dart';

class PostService {
  final imageService = ImageService();
  final users = FirebaseFirestore.instance.collection('posts');

  Future<String?> uploadPostPhoto(PostModel? currentPost) async {
    XFile? image = await imageService.pickImageFromGallery();

    if (image != null && currentPost != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final profileImageRef = storageRef.child('posts/${currentPost.uid}/post.jpg');
      
      File imageFile = File(image.path);
      profileImageRef.putFile(imageFile);

      return profileImageRef.getDownloadURL();
    }

    return null;
  }

  Future<String> createPosts(String uid, String text) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc();
    final postId = postRef.id;

    await postRef.set({
      'id': postId,
      'userId': uid,
      'text': 'Mon premier post !', 
      'imageUrl': null,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
      'likes': 0,
      'comments': [],
    });

    return postId;
  }

  Future<void> updateProfilePhoto(String uid, String photoUrl) async {
    await users.doc(uid).update({
      'photoUrl': photoUrl,
    });
  }
}