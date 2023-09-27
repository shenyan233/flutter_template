import 'package:flutter_xupdate/flutter_xupdate.dart';

///初始化
Future<void> initUpdate() async {
  await FlutterXUpdate.init(
    isWifiOnly: false,
  ).catchError((error) {
    print(error);
    return null;
  });
}

//默认App更新
void checkUpdateDefault(String _updateUrl) {
  FlutterXUpdate.checkUpdate(url: _updateUrl);
}
