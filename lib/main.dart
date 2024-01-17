import 'package:flutter/material.dart';
import 'package:flutter_template/page/components/responsive.dart';
import 'package:flutter_template/routes.dart';
import 'package:flutter_template/state.dart';
import 'package:provider/provider.dart';
import 'app_setting.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:seo/seo.dart';
import 'dart:js';
import 'package:intl/intl.dart';

void main() {
  usePathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key}) {
    print('MyApp()');
    delegate.pushRoute(name: '/home');
  }

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  static AppSetting setting = AppSetting();

  @override
  void initState() {
    super.initState();
    setting.changeLocale = (Locale locale) {
      setState(() {
        if (PlatformUtils.isWeb) {
          String curUrl = context['location']['href'];
          curUrl = curUrl.replaceAll(Intl.defaultLocale!, locale.languageCode);
          context.callMethod(
              'eval', ["window.history.pushState(null, '', '$curUrl');"]);
        }
        setting.locale = locale;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    // 进行打开app必须的初始化，其他的非必须初始化尽量放在initPage
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LoginStatus(false)),
      ],
      child: SeoController(
        enabled: true,
        tree: WidgetTree(context: context),
        child: MaterialApp.router(
          //初始化的时候加载的路由
          routerDelegate: delegate,
          routeInformationParser: const MyRouteInformationParser(),
          locale: setting.locale,
          // 设置中文为首选项
          supportedLocales: [
            const Locale('zh', ''),
            ...S.delegate.supportedLocales
          ],
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
        ),
      ),
    );
  }
}
