import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String uid;
  final String userId;
  final String text;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likes;
  final List<String> comments;

  PostModel({
    required this.uid,
    required this.userId,
    required this.text,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.likes,
    required this.comments,
  });

  factory PostModel.fromMap(Map<String, dynamic> map, String documentId) {
    print("Map du post model");
    return PostModel(
      uid: documentId,
      userId: map['userId'],
      text: map['text'] ?? '',
      imageUrl: map['imageUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      likes: map['likes'] ?? 0,
      comments: List<String>.from(map['comments'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'text': text,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'likes': likes,
      'comments': comments,
    };
  }
}
