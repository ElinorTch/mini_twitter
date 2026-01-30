import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String pseudo;
  final String? photoUrl;
  final String? bio;
  final List<String> followers;
  final List<String> following;
  final DateTime joinedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.pseudo,
    this.photoUrl,
    this.bio,
    required this.followers,
    required this.following,
    required this.joinedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      email: map['email'] ?? '',
      pseudo: map['pseudo'] ?? '',
      photoUrl: map['photoUrl'],
      bio: map['bio'],
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      joinedAt: (map['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'pseudo': pseudo,
      'photoUrl': photoUrl,
      'bio': bio,
      'followers': followers,
      'following': following,
      'joinedAt': joinedAt,
    };
  }

  UserModel copyWith({
    String? email,
    String? pseudo,
    String? photoUrl,
    String? bio,
    List<String>? followers,
    List<String>? following,
  }) {
    return UserModel(
      uid: uid,
      email: email ?? this.email,
      pseudo: pseudo ?? this.pseudo,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      joinedAt: joinedAt,
    );
  }
}