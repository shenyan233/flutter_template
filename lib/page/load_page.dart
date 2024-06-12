import 'package:flutter/material.dart';
import '../model/database.dart';
import 'components/check_args.dart';
import 'components/responsive.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  bool flagDelay = false;

  @override
  void initState() {
    if (!hasInit) {
      initApp(context);
      if (PlatformUtils.isAndroid || PlatformUtils.isIOS) {
        Future.delayed(const Duration(seconds: 4)).then((value) {
          flagDelay = true;
        });
      } else {
        flagDelay = true;
      }
    }
    super.initState();
  }

  Future<void> initApp(context) async {
    // 初始化数据库
    if (PlatformUtils.isAndroid ||
        PlatformUtils.isIOS ||
        PlatformUtils.isMacOS) {
      await DatabaseOperate.init();
    }
    // 初始化服务器
    // 初始化更新
    // await initUpdate();
    checkDelay();
  }

  void checkDelay() {
    if (flagDelay) {
      hasInit = true;
    } else {
      Future.delayed(const Duration(seconds: 1)).then((value) {
        checkDelay();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    if (hasInit) {
      super.dispose();
    } else {
      Future.delayed(const Duration(seconds: 1)).then((value) => dispose());
    }
  }
}
