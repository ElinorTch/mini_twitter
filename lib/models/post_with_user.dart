import '../database/app_database.dart';

class PostWithUser {
  final Post post;
  final User user;

  PostWithUser({
    required this.post,
    required this.user,
  });
}