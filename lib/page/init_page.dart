import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/page/responsive.dart';
import '../generated/l10n.dart';
import '../init/routes.dart';
import '../model/database.dart';
import '../model/sputils.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  bool flag = false;

  void initApp(context) {
    Future(() async {
      // SharedPreferences的初始化
      await SPUtils.init();
      // 初始化数据库
      if (PlatformUtils.isAndroid || PlatformUtils.isIOS || PlatformUtils.isMacOS) {
        await DatabaseOperate.init();
      }
      // 初始化服务器
      // 初始化更新
      // await initUpdate();
      flag = true;
    });
  }

  void delayNavigator(context, Duration duration) async {
    Future.delayed(duration).then((value) async {
      if (flag) {
        delegate.replace(name: '/home');
      } else {
        delayNavigator(context, const Duration(milliseconds: 1));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    initApp(context);
    delayNavigator(context, const Duration(seconds: 4));
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: S.current.appName,
      primaryColor: 0xFFE3F2FD,
    ));
    return const Scaffold(
      body: Center(
        child: Text('加载中'),
      ),
    );
  }
}
