import 'package:flutter/material.dart';
import '../page/init_page.dart';

//使用方法：
// 无传参
// Navigator.pushNamed(context, '/');
// 传参：
// 配置方法
//'/productinfo':(context,{arguments})=>ProductInfoPage(arguments:arguments),
// 跳转方法
// Navigator.pushNamed(context, '/',arguments: arguments);
//配置路由
final routes = {
  // 其中必须要有'/'这个路由名称，不然就报错。因为flutter会默认增加一个'/'，这很莫名其妙.
  '/': (context) => InitPage(),
};

//固定写法
Route onGenerateRoute(RouteSettings settings) {
  // 统一处理
  final String name = settings.name!;
  final Function pageContentBuilder = routes[name]!;
  if (settings.arguments != null) {
    final Route route = MaterialPageRoute(
        builder: (context) =>
            pageContentBuilder(context, arguments: settings.arguments));
    return route;
  } else {
    final Route route =
        MaterialPageRoute(builder: (context) => pageContentBuilder(context));
    return route;
  }
}
