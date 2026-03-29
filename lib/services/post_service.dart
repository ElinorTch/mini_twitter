import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mini_twitter/models/post.dart';
import 'package:mini_twitter/models/user.dart';
import 'package:mini_twitter/services/image_service.dart';
import 'package:mini_twitter/services/user_service.dart';

class PostService {
  final imageService = ImageService();
  final posts = FirebaseFirestore.instance.collection('posts');
  final userService = UserService();

  DocumentSnapshot? lastDoc;
  bool hasMore = true;

  Future<String?> uploadPostPhoto(String postId, String? imagePath) async {
    if (imagePath != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final profileImageRef = storageRef.child('posts/$postId/post.jpg');

      File imageFile = File(imagePath);
      await profileImageRef.putFile(imageFile);

      updatePostImageUrl(postId, await profileImageRef.getDownloadURL());
    }

    return null;
  }

  Future<String> createPosts(PostModel post) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc();
    final postId = postRef.id;

    await postRef.set(post.toMap());

    return postId;
  }

  Future<void> updatePostImageUrl(String postId, String newImageUrl) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    await postRef.update({'imageUrl': newImageUrl});
  }

  Future<List<PostModel>> getFollowingPosts(
    List<String> followingIds, {
    int limit = 10,
  }) async {
    // if (!hasMore) return [];

    print("Fetching following posts for IDs: $followingIds");

    // return [] as List<PostModel>;

    if (followingIds.isEmpty) return [];

    Query query = posts.where('userId', whereIn: followingIds);
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

    print('is empty: ${snapshot.docs.isEmpty}');
    print("doc ${snapshot.docs.map((doc) => doc.data())}");

    return snapshot.docs
        .map(
          (doc) =>
              PostModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  Future<List<PostModel>> getLikedPosts(
    String currentUserId, {
    int limit = 10,
  }) async {
    print('currentUserId: $currentUserId');
    UserModel? user = await userService.getUserById(currentUserId);

    if (user == null || user.likedPosts.isEmpty) {
      return [];
    }

    List<PostModel> likedPosts = [];

    for (var likedPostId in user.likedPosts) {
      final snapshot = await posts.doc(likedPostId).get();

      likedPosts.add(
        PostModel.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id),
      );
    }

    return likedPosts;
  }

  Future<List<PostModel>> getMyPosts(
    String currentUserId, {
    int limit = 10,
  }) async {
    // if (!hasMore) return [];

    // if (currentUserId.isEmpty) return [];

    print("Fetching my posts");

    Query query = posts
        .where('userId', isEqualTo: currentUserId)
        .orderBy('createdAt', descending: true);
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

    return snapshot.docs
        .map(
          (doc) =>
              PostModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }
}
