import 'package:flutter/material.dart';

import '../init/routes.dart';

class SubpageArgs extends StatefulWidget {
  final String message;

  SubpageArgs({Key? key, args})
      : message = (args != null && (args as Map).containsKey('message'))
            ? args['message']
            : '无参数',
        super(key: key);

  @override
  State<SubpageArgs> createState() => _SubpageArgsState();
}

class _SubpageArgsState extends State<SubpageArgs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SelectableText(widget.message),
            ElevatedButton(
              onPressed: () {
                delegate.pushRoute(name: '/subpage');
              },
              child: const Text('进入subpage'),
            ),
            ElevatedButton(
              onPressed: () {
                Router.of(context).routerDelegate.popRoute();
              },
              child: const Text('返回'),
            ),
          ],
        ),
      ),
    );
  }
}
