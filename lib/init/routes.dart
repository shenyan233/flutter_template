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
import 'package:flutter/material.dart';

import 'package:flutter_template/page/init_page.dart' deferred as init_page;
import 'package:flutter_template/page/home_page.dart' deferred as home_page;
import 'package:flutter_template/page/subpage.dart' deferred as subpage;
import 'package:flutter_template/page/subpage_args.dart'
    deferred as subpage_args;

MyRouterDelegate delegate = MyRouterDelegate();

class MyRouterDelegate extends RouterDelegate<List<RouteSettings>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<RouteSettings>> {
  final List<Page> _pages = [];

  List<Page> get page => _pages;

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
      _pages.removeLast();
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> popRoute() {
    if (canPop()) {
      _pages.removeLast();
      notifyListeners();
      return Future.value(true);
    }
    return Future.value(false);
  }

  void pushRoute({required String name, dynamic arguments}) {
    _pages.add(_createPage(RouteSettings(name: name, arguments: arguments)));
    notifyListeners();
  }

  void replaceRoute({required String name, dynamic arguments}) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    pushRoute(name: name, arguments: arguments);
  }

  AsyncWidgetBuilder _builder(func) {
    return (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return func();
      }
      return const CircularProgressIndicator();
    };
  }

  MaterialPage _createPage(RouteSettings routeSettings) {
    Widget child;

    switch (routeSettings.name) {
      case '/init':
        child = FutureBuilder(
          future: init_page.loadLibrary(),
          builder: _builder(() => init_page.InitPage()),
        );
        break;
      case '/home':
        child = FutureBuilder(
          future: home_page.loadLibrary(),
          builder: _builder(() => home_page.HomePage()),
        );
        break;
      case '/subpage':
        child = FutureBuilder(
          future: subpage.loadLibrary(),
          builder: _builder(() => subpage.Subpage()),
        );
        break;
      case '/subpage_args':
        child = FutureBuilder(
          future: subpage_args.loadLibrary(),
          builder: _builder(
              () => subpage_args.SubpageArgs(args: routeSettings.arguments)),
        );
        break;
      default:
        child = const Center(
          child: Text('找不到页面'),
        );
    }

    return MaterialPage(
      child: child,
      key: Key(routeSettings.name!) as LocalKey,
      name: routeSettings.name,
      arguments: routeSettings.arguments,
    );
  }

  @override
  List<Page> get currentConfiguration => List.of(_pages);

  void _setPath(List<Page> pages) {
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
    final uri = routeInformation.uri;

    if (uri.pathSegments.isEmpty) {
      return Future.value([const RouteSettings(name: '/init')]);
    }

    final routeSettings = uri.toString().split('/').sublist(1).map((pathSegment) {
      var uri = Uri.parse(pathSegment);
      return RouteSettings(
        name: '/${uri.pathSegments[0]}',
        arguments: uri.queryParameters,
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
    String url = '';
    for (RouteSettings routeSetting in configuration) {
      var location = routeSetting.name;
      var arguments = _restoreArguments(routeSetting);
      url += '$location$arguments';
    }
    return RouteInformation(uri: Uri.parse(url));
  }

  String _restoreArguments(RouteSettings routeSettings) {
    if (routeSettings.arguments == null) {
      return '';
    }
    String result = '?';
    (routeSettings.arguments as Map).forEach((key, value) {
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
