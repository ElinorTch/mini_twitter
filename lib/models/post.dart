import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String uid;
  final String userId;
  final String text;
  final String? imageUrl;
  final DateTime createdAt;
  final int likes;
  final List<String> comments;

  PostModel({
    required this.uid,
    required this.userId,
    required this.text,
    this.imageUrl,
    required this.createdAt,
    required this.likes,
    required this.comments,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      uid: map['uid'],
      userId: map['userId'],
      text: map['text'] ?? '',
      imageUrl: map['imageUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      likes: map['likes'] ?? 0,
      comments: List<String>.from(map['comments'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userId': userId,
      'text': text,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'likes': likes,
      'comments': comments,
    };
  }
}