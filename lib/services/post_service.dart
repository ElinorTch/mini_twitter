import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_twitter/models/post.dart';
import 'package:mini_twitter/services/image_service.dart';

class PostService {
  final imageService = ImageService();
  final posts = FirebaseFirestore.instance.collection('posts');
  DocumentSnapshot? lastDoc;
  bool hasMore = true;

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

  Future<List<PostModel>> getFollowingPosts(
    List<String> followingIds, {
    int limit = 10,
  }) async {
    if (!hasMore) return [];

    print("Fetching following posts for IDs: $followingIds");

    if (followingIds.isEmpty) return []; 

    Query query = posts
        .where('userId', whereIn: followingIds)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc!);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      lastDoc = snapshot.docs.last;
    }

    if (snapshot.docs.length < limit) {
      hasMore = false;
    }

    return snapshot.docs
        .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<List<PostModel>> getMyPosts(
    String currentUserId, {
    int limit = 10,
  }) async {
    // if (!hasMore) return [];

    // if (currentUserId.isEmpty) return [];

    // print("Fetching my posts");

    Query query = posts
        .where('likes', isEqualTo: 5);
        // .orderBy('createdAt', descending: true);
        // .limit(limit);

    // if (lastDoc != null) {
    //   query = query.startAfterDocument(lastDoc!);
    // }

    final snapshot = await query.get();

    // if (snapshot.docs.isNotEmpty) {
    //   lastDoc = snapshot.docs.last;
    // }

    // if (snapshot.docs.length < limit) {
    //   hasMore = false;
    // }

    print("Posts fetched: ${snapshot.docs} for user ID: $currentUserId");

    return snapshot.docs
        .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}