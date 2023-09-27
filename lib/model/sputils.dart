import 'package:shared_preferences/shared_preferences.dart';

class SPUtils {
  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  SPUtils._internal();

  static late SharedPreferences spf;

  static init() async {
    spf = await SharedPreferences.getInstance();
  }
}
