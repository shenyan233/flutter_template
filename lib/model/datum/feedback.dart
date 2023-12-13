import '../database.dart';

class UserFeedback extends Datum {
  String content;

  UserFeedback(this.content);

  // 生成对象，如果生成失败，则返回null
  static UserFeedback? generate(String? content) {
    return content == null ? null : UserFeedback(content);
  }


  @override
  toJson(bool isNative){

  }
}
