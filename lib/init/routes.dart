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

  FutureBuilder<T> _creatFutureBuilder<T>(Future<T> lib, Widget page) {
    return FutureBuilder<T>(
      future: lib,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return page;
        }
        return const CircularProgressIndicator();
      },
    );
  }

  MaterialPage _createPage(RouteSettings routeSettings) {
    Widget child;

    switch (routeSettings.name) {
      case '/init':
        child =
            _creatFutureBuilder(init_page.loadLibrary(), init_page.InitPage());
        break;
      case '/':
        child =
            _creatFutureBuilder(home_page.loadLibrary(), home_page.HomePage());
        break;
      case '/subpage':
        child = _creatFutureBuilder(subpage.loadLibrary(), subpage.Subpage());
        break;
      case '/subpage_args':
        child = _creatFutureBuilder(subpage_args.loadLibrary(),
            subpage_args.SubpageArgs(args: routeSettings.arguments));
        break;
      default:
        print(routeSettings.name);
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

    final routeSettings = uri.pathSegments
        .map((pathSegment) => RouteSettings(
              name: '/$pathSegment',
              arguments: pathSegment == uri.pathSegments.last
                  ? uri.queryParameters
                  : null,
            ))
        .toList();

    return Future.value(routeSettings);
  }

  @override
  RouteInformation restoreRouteInformation(List<RouteSettings> configuration) {
    final location = configuration.last.name;
    final arguments = _restoreArguments(configuration.last);

    return RouteInformation(uri: Uri.parse('$location$arguments'));
  }

  String _restoreArguments(RouteSettings routeSettings) {
    if (routeSettings.name != '/details') return '';
    var args = routeSettings.arguments as Map;

    return '?name=${args['name']}&imgUrl=${args['imgUrl']}';
  }
}
