import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../generated/l10n.dart';
import '../model/database.dart';
import '../state.dart';
import '../model/sputils.dart';
import 'components/check_args.dart';
import 'components/responsive.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({Key? key}) : super(key: key);

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  bool flagDelay = false;

  @override
  void initState() {
    if(!hasInit){
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
    if (PlatformUtils.isWeb){
      await SystemChrome.setApplicationSwitcherDescription(
          ApplicationSwitcherDescription(
            label: S.current.appName,
          ));
    }
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
    // 初始化更新
    // await initUpdate();
    checkDelay();
  }

  void checkDelay(){
    if(flagDelay){
      hasInit = true;
    }else{
      Future.delayed(const Duration(seconds: 1)).then((value){
        checkDelay();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    if(hasInit){
      super.dispose();
    }else{
      Future.delayed(const Duration(seconds: 1)).then((value) => dispose());
    }
  }
}
