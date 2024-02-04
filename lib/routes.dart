//使用方法：
// 返回
// Router.of(context).routerDelegate.popRoute();
// 无传参
// delegate.push(name: '/init');
// 传参：
// 配置方法
// child = SubpageArgs(args: routeSettings.arguments);
// 跳转方法
// delegate.push(name: '/init',arguments: arguments);
import 'dart:async';
import 'package:flutter/material.dart';
import 'app_setting.dart';
import 'generated/l10n.dart';
import 'page/error_page.dart' deferred as error_page;
import 'package:flutter_template/page/home_page.dart' deferred as home_page;
import 'package:flutter_template/page/subpage.dart' deferred as subpage;
import 'package:flutter_template/page/subpage_args.dart'
    deferred as subpage_args;
import 'page/components/check_args.dart';
import 'page/load_page.dart';
import 'package:intl/intl.dart';

MyRouterDelegate delegate = MyRouterDelegate();

class CustomPage<T> extends MaterialPage<T> {
  final Completer completerResult = Completer();

  CustomPage({
    required super.child,
    super.maintainState = true,
    super.fullscreenDialog = false,
    super.allowSnapshotting = true,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });
}

class MyRouterDelegate extends RouterDelegate<List<RouteSettings>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<RouteSettings>> {
  final List<CustomPage> _pages = [];

  List<CustomPage> get page => _pages;

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: List.of(_pages),
      onPopPage: _onPopPage,
    );
  }

  bool canPop() {
    return _pages.length > 1;
  }

  bool _onPopPage(Route route, dynamic result) {
    if (!route.didPop(result)) return false;

    if (canPop()) {
      CustomPage page = _pages.removeLast();
      notifyListeners();
      page.completerResult.complete();
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> popRoute() {
    if (canPop()) {
      CustomPage page = _pages.removeLast();
      notifyListeners();
      page.completerResult.complete();
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<void> pushRoute({required String name, dynamic arguments}) async {
    print('pushRoute $name');
    CustomPage page =
        _createPage(RouteSettings(name: name, arguments: arguments));
    _pages.add(page);
    notifyListeners();
    return await page.completerResult.future;
  }

  void replaceRoute({required String name, dynamic arguments}) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    pushRoute(name: name, arguments: arguments);
  }

  AsyncWidgetBuilder _builder(page) {
    return (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return page;
      }
      return const LoadPage();
    };
  }

  Future afterInit(Future future) async {
    if (hasInit) {
      return future;
    } else {
      await Future.delayed(const Duration(seconds: 1));
      return afterInit(future);
    }
  }

  CustomPage _createPage(RouteSettings routeSettings) {
    Widget child;

    switch (routeSettings.name) {
      case '/home':
        child = FutureBuilder(
          future: afterInit(home_page.loadLibrary()),
          builder: _builder(home_page.HomePage()),
        );
        break;
      case '/subpage':
        child = FutureBuilder(
          future: afterInit(subpage.loadLibrary()),
          builder: _builder(subpage.Subpage()),
        );
        break;
      case '/subpage_args':
        child = FutureBuilder(
          future: afterInit(subpage_args.loadLibrary()),
          builder: _builder(
              subpage_args.SubpageArgs(args: routeSettings.arguments as Map?)),
        );
        break;
      default:
        child = FutureBuilder(
          future: afterInit(error_page.loadLibrary()),
          builder: _builder(error_page.ErrorPage()),
        );
    }

    return CustomPage(
      child: child,
      key: Key(routeSettings.name!) as LocalKey,
      name: routeSettings.name,
      arguments: routeSettings.arguments,
    );
  }

  @override
  List<CustomPage> get currentConfiguration => List.of(_pages);

  void _setPath(List<CustomPage> pages) {
    _pages.clear();
    _pages.addAll(pages);

    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(List<RouteSettings> configuration) {
    _setPath(configuration
        .map((routeSettings) => _createPage(routeSettings))
        .toList());
    return Future.value(null);
  }
}

class MyRouteInformationParser
    extends RouteInformationParser<List<RouteSettings>> {
  const MyRouteInformationParser() : super();

  @override
  Future<List<RouteSettings>> parseRouteInformation(
      RouteInformation routeInformation) {
    print('parseRouteInformation');
    final uri = routeInformation.uri;

    if (uri.pathSegments.isEmpty) {
      return Future.value([const RouteSettings(name: '/home')]);
    }

    final routeSettings = uri.toString().split('/').sublist(1).map((element) {
      // 如果采用将固定参数作为替换，如replaceArg，则会导致页面内改变不会修改到
      // RouteSettings中，进入下一层页面后会导致修改的内容不会映射到URL中
      Locale locale = Locale.fromSubtags(languageCode: element);
      if (S.delegate.supportedLocales.contains(locale)) {
        Future(() {
          AppSetting.changeLocale!(locale);
        });
        element = 'home';
      }
      Uri uri = Uri.parse(element);
      return RouteSettings(
        name: '/${uri.pathSegments[0]}',
        arguments: uri.queryParameters.isEmpty
            ? {}
            : {'urlRequest': uri.queryParameters},
      );
    }).toList();

    return Future.value(routeSettings);
  }

  Map uriArgs2map(String uriArgs) {
    var uriArgsList = uriArgs.split('&');
    Map map = {};
    for (String arg in uriArgsList) {
      var argList = arg.split('=');
      var key = argList[0];
      var value = argList[1];
      map[key] = value;
    }
    return map;
  }

  @override
  RouteInformation restoreRouteInformation(List<RouteSettings> configuration) {
    print('restoreRouteInformation');
    String url = '';
    for (RouteSettings routeSetting in configuration) {
      var location = routeSetting.name == '/home'
          ? '/${Intl.defaultLocale}'
          : routeSetting.name;
      var arguments = _restoreArguments(routeSetting);
      url += '$location$arguments';
    }
    return RouteInformation(uri: Uri.parse(url));
  }

  String _restoreArguments(RouteSettings routeSettings) {
    if (routeSettings.arguments == null ||
        !((routeSettings.arguments as Map).containsKey('urlRequest'))) {
      return '';
    }
    String result = '?';
    (routeSettings.arguments as Map)['urlRequest'].forEach((key, value) {
      result += "$key=$value&";
    });
    if (result == '?') {
      result = '';
    } else {
      result = result.substring(0, result.length - 1);
    }
    return result;
  }
}
