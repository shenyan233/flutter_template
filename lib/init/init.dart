import 'package:flutter/material.dart';
import 'package:flutter_template/init/routes.dart';
import 'package:flutter_template/init/state.dart';
import 'package:provider/provider.dart';
import '../generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // 进行打开app必须的初始化，其他的非必须初始化尽量放在initPage
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LoginStatus(false)),
      ],
      child: MaterialApp(
        //初始化的时候加载的路由
        initialRoute: '/',
        onGenerateRoute: onGenerateRoute,
        // 设置中文为首选项
        supportedLocales: [
          const Locale('zh', ''), ...S.delegate.supportedLocales
        ],
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
      ),
    );
  }
}
