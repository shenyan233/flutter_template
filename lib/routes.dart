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
import 'page/error_page.dart' deferred as error_page;
import 'package:flutter_template/page/home_page.dart' deferred as home_page;
import 'package:flutter_template/page/subpage.dart' deferred as subpage;
import 'package:flutter_template/page/subpage_args.dart'
    deferred as subpage_args;

import 'page/components/check_args.dart';
import 'page/load_page.dart';

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
      return const LoadPage();
    };
  }

  Future afterInit(Future future) async {
    if(hasInit){
      return future;
    }else{
      await Future.delayed(const Duration(seconds: 1));
      return afterInit(future);
    }
  }

  MaterialPage _createPage(RouteSettings routeSettings) {
    Widget child;

    switch (routeSettings.name) {
      case '/home':
        child = FutureBuilder(
          future: afterInit(home_page.loadLibrary()),
          builder: _builder(() => home_page.HomePage()),
        );
        break;
      case '/subpage':
        child = FutureBuilder(
          future: afterInit(subpage.loadLibrary()),
          builder: _builder(() => subpage.Subpage()),
        );
        break;
      case '/subpage_args':
        child = FutureBuilder(
          future: afterInit(subpage_args.loadLibrary()),
          builder: _builder(
              () => subpage_args.SubpageArgs(args: routeSettings.arguments as Map?)),
        );
        break;
      default:
        child = FutureBuilder(
          future: afterInit(error_page.loadLibrary()),
          builder: _builder(() => error_page.ErrorPage()),
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
      return Future.value([const RouteSettings(name: '/home')]);
    }

    final routeSettings = uri.toString().split('/').sublist(1).map((pathSegment) {
      var uri = Uri.parse(pathSegment);
      return RouteSettings(
        name: '/${uri.pathSegments[0]}',
        arguments: uri.queryParameters.isEmpty?{}:{'urlRequest': uri.queryParameters},
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
      if (routeSetting.name!='/home') {
        var location = routeSetting.name;
        var arguments = _restoreArguments(routeSetting);
        url += '$location$arguments';
      }
    }
    return RouteInformation(uri: Uri.parse(url));
  }

  String _restoreArguments(RouteSettings routeSettings) {
    if (routeSettings.arguments == null || !((routeSettings.arguments as Map).containsKey('urlRequest'))) {
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
