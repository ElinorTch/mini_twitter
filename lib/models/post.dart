import 'package:hive/hive.dart';

part 'post.g.dart';

@HiveType(typeId: 0)
class Post extends HiveObject {
  @HiveField(0)
  String content;

  @HiveField(1)
  DateTime createdAt;

  @HiveField(2)
  int authorId; 

  Post({
    required this.content,
    required this.createdAt,
    required this.authorId,
  });
}