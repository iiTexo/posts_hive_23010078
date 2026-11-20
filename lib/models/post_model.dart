import 'package:hive/hive.dart';

part 'post_model.g.dart';

@HiveType(typeId: 0)
class Post extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String body;

  @HiveField(3)
  int userId;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['userId'],
    );
  }

  // A HiveObject can only live in one box at a time, so favourites are
  // stored as a copy instead of the instance that already sits in postsBox.
  Post copy() => Post(id: id, title: title, body: body, userId: userId);
}
