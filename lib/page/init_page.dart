import 'package:flutter/material.dart';
import '../generated/l10n.dart';
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
      await DatabaseOperate.init();
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
    delayNavigator(context, const Duration(seconds: 4));

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 250),
              child: Text(
                S.of(context).appName,
                style: const TextStyle(fontSize: 50),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 150),
              child: SizedBox(
                height: 150,
                width: 150,
                child: ClipOval(
                    //child: Image.asset('assets/imgs/XX.png'),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
