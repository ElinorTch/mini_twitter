import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String? uid;
  final String userId;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likes = 0;
  final List<String> comments = [];
  String? imageUrl;

  PostModel({
    required this.userId,
    required this.text,
    this.imageUrl,
    this.uid,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PostModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PostModel(
      uid: documentId,
      userId: map['userId'],
      text: map['text'],
      imageUrl: map['imageUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
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
