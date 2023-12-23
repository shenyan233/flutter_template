import 'package:flutter/material.dart';
import 'package:flutter_template/routes.dart';
import 'package:flutter_template/state.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key) {
    // 初始化时添加第一个页面
    delegate.pushRoute(name: '/init');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // 进行打开app必须的初始化，其他的非必须初始化尽量放在initPage
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LoginStatus(false)),
      ],
      child: MaterialApp.router(
        //初始化的时候加载的路由
        routerDelegate: delegate,
        routeInformationParser: MyRouteInformationParser(),
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
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
