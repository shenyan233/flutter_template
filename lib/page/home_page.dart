import 'package:flutter/material.dart';
import 'package:flutter_template/page/responsive.dart';
import '../generated/l10n.dart';
import '../init/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              S.of(context).appName,
              style: const TextStyle(fontSize: 50),
            ),
            if (Responsive.isMobile(context))
              const Text(
                '该设备是手机',
                style: TextStyle(fontSize: 50),
              ),
            if (Responsive.isTablet(context))
              const Text(
                '该设备是平板',
                style: TextStyle(fontSize: 50),
              )
            else if (Responsive.isDesktop(context))
              const Text(
                '该设备是电脑',
                style: TextStyle(fontSize: 50),
              ),
            ElevatedButton(
              onPressed: () {
                delegate.push(name: '/subpage');
              },
              child: const Text('进入无参数子页面'),
            ),
            ElevatedButton(
              onPressed: () {
                delegate.push(name: '/subpage_args', arguments: {'message': '传递的信息'});
              },
              child: const Text('进入带参数子页面'),
            ),
          ],
        ),
      ),
    );
  }
}
