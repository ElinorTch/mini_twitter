import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String avatarUrl;

  @HiveField(2)
  List<int> postIds; 

  User({
    required this.username,
    required this.avatarUrl,
    required this.postIds,
  });
}