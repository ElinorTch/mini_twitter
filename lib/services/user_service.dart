import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final users = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(String uid, String email, String pseudo) async {
    await users.doc(uid).set({
      'email': email,
      'pseudo': pseudo,
      'aboutMe': 'This section is meant to be my bio...',
      'followers': [],
      'following': [],
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> pseudoExists(String pseudo) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('pseudo', isEqualTo: pseudo)
        .limit(1)
        .get();

    return query.docs.isNotEmpty; 
  }


  // ➕ Follow
  Future<void> follow(String currentUserId, String targetUserId) async {
    await users.doc(targetUserId).update({
      'followers': FieldValue.arrayUnion([currentUserId])
    });

    await users.doc(currentUserId).update({
      'following': FieldValue.arrayUnion([targetUserId])
    });
  }

  // ➖ Unfollow
  Future<void> unfollow(String currentUserId, String targetUserId) async {
    await users.doc(targetUserId).update({
      'followers': FieldValue.arrayRemove([currentUserId])
    });

    await users.doc(currentUserId).update({
      'following': FieldValue.arrayRemove([targetUserId])
    });
  }
}