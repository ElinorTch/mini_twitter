class PostModel {
  final String? uid;
  final String userId;
  final String text;
  final DateTime createdAt = DateTime.now();
  final DateTime updatedAt = DateTime.now();
  final int likes = 0;
  final List<String> comments = [];
  String? imageUrl;

  PostModel({
    required this.userId,
    required this.text,
    this.imageUrl,
    this.uid,
  });

  factory PostModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PostModel(
      uid: documentId,
      userId: map['userId'],
      text: map['text'] ?? '',
      imageUrl: map['imageUrl'],
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
