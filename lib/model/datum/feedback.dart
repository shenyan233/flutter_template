import '../database.dart';

class UserFeedback extends Entity {
  String tableName = 'UserFeedback';
  String content;

  UserFeedback(this.content);

  factory UserFeedback.fromJson(Map<String, dynamic> json) => UserFeedback(
    json['content'] as String,
  );

  @override
  toJson() {
  }
}
