import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_twitter/data/models/user_model.dart';
import 'package:mini_twitter/data/services/image_service.dart';

class UserService {
  final imageService = ImageService();
  final users = FirebaseFirestore.instance.collection('users');
  Map<String, UserModel> usersCache = {};

  Future<User?> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser!;
  }

  Future<UserModel?> getUser(String userId) async {
    if (usersCache.containsKey(userId)) {
      return usersCache[userId];
    }

    final user = await getUserById(userId);

    if (user == null) {
      print("⚠️ User not found in Firestore: $userId");
      return null;
    }

    usersCache[userId] = user;

    return user;
  }

  Future<String?> uploadUserProfilePhoto(UserModel? currentUser) async {
    XFile? image = await imageService.pickImageFromGallery();

    if (image != null && currentUser != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final profileImageRef = storageRef.child(
        'users/${currentUser.uid}/profile.jpg',
      );

      File imageFile = File(image.path);
      profileImageRef.putFile(imageFile);

      return profileImageRef.getDownloadURL();
    }

    return null;
  }

  Future<void> createUser(String uid, String email, String pseudo) async {
    await users.doc(uid).set({
      'email': email,
      'pseudo': pseudo,
      'bio': 'This section is meant to be my bio...',
      'followers': [],
      'following': [],
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateProfilePhoto(String uid, String photoUrl) async {
    await users.doc(uid).update({'photoUrl': photoUrl});
  }

  Future<UserModel?> getUserById(String uid) async {
    DocumentSnapshot doc = await users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data() as Map<String, dynamic>, uid);
  }

  Future<bool> pseudoExists(String pseudo) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('pseudo', isEqualTo: pseudo)
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }

  Future<void> addLikedPost(String userId, String postId) async {
    await users.doc(userId).update({
      'likedPosts': FieldValue.arrayUnion([postId]),
    });
  }

  Future<void> removeLikedPost(String userId, String postId) async {
    await users.doc(userId).update({
      'likedPosts': FieldValue.arrayRemove([postId]),
    });
  }

  Future<void> followUser(String currentUserId, String targetUserId) async {
    await users.doc(currentUserId).update({
      'following': FieldValue.arrayUnion([targetUserId]),
    });

    await users.doc(targetUserId).update({
      'followers': FieldValue.arrayUnion([currentUserId]),
    });
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    await users.doc(currentUserId).update({
      'following': FieldValue.arrayRemove([targetUserId]),
    });

    await users.doc(targetUserId).update({
      'followers': FieldValue.arrayRemove([currentUserId]),
    });
  }
}
