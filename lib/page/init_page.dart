import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/page/responsive.dart';
import '../generated/l10n.dart';
import '../model/database.dart';
import '../model/sputils.dart';
import 'dart:io';

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
      if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
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
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
      } else {
        delayNavigator(context, const Duration(seconds: 1));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    initApp(context);
    // delayNavigator(context, const Duration(seconds: 4));
    SystemChrome.setApplicationSwitcherDescription(ApplicationSwitcherDescription(
      label: S.current.appName,
      primaryColor: 0xFFE3F2FD,
    ));
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              S.of(context).appName,
              style: const TextStyle(fontSize: 50),
            ),
            if (Responsive.isMobile(context))
              const Text(
                '该设备是手机',
                style: TextStyle(fontSize: 50),
              ),
            if (Responsive.isTablet(context))
              const Text(
                '该设备是平板',
                style: TextStyle(fontSize: 50),
              )
            else if (Responsive.isDesktop(context))
              const Text(
                '该设备是电脑',
                style: TextStyle(fontSize: 50),
              ),
          ],
        ),
      ),
    );
  }
}
