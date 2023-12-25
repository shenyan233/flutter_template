// 本地和云端的数据需要区分，因为两者可能数据类型不同，或者toJson的级别不同，本地数据需要一步到位，
// 而云端不需要
// 本地数据获取后，如果无关联表，则可视为和云端数据相同，如果存在关联表，则查询关联表作为map后视为
// 和云端数据相同
// 该数据为基本数据类型，继承云端数据类型即可进行上传，同时本地数据保存也依赖该类
abstract class Entity<T>{
  // 为了保证该数据类型适应于不同的服务器类型，如Object或者User，而不用分别建立两个Entity，
  // 此处用传入的方式，而不用继承的方式
  late T _serverObject;

  toJson(){}

  Future serverSave() async {
    // TODO 这里需要补充保存逻辑
    // await this.save();
  }
}

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