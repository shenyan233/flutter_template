import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/page/components/responsive.dart';
import 'package:provider/provider.dart';
import '../generated/l10n.dart';
import '../routes.dart';
import '../state.dart';
import '../model/database.dart';
import '../model/sputils.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  bool flag = false;

  @override
  void initState() {
    initApp(context);
    if (PlatformUtils.isAndroid || PlatformUtils.isIOS) {
      delayNavigator(context, const Duration(seconds: 4));
    } else {
      delayNavigator(context, const Duration(seconds: 0));
    }
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
          label: S.current.appName,
        ));
    super.initState();
  }

  void initApp(context) {
    Future(() async {
      // SharedPreferences的初始化
      await SPUtils.init();
      // 初始化数据库
      if (PlatformUtils.isAndroid ||
          PlatformUtils.isIOS ||
          PlatformUtils.isMacOS) {
        await DatabaseOperate.init();
      }
      // 初始化服务器
      //初始化登陆状态
      LoginStatus loginStatus = Provider.of<LoginStatus>(context, listen: false);
      loginStatus.isLogin = SPUtils.spf.getString('username') == null ||
          SPUtils.spf.getString('username')!.isEmpty
          ? false
          : true;
      flag = true;
    });
  }

  void delayNavigator(context, Duration duration) {
    Future.delayed(duration).then((value) {
      if (flag) {
        if ((delegate.page[0]).name == '/init'){
          delegate.replaceRoute(name: '/home');
        }
      } else {
        delayNavigator(context, const Duration(milliseconds: 1));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('加载中'),
      ),
    );
  }
}
