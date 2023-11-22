import 'package:flutter/material.dart';

class Subpage extends StatefulWidget {
  const Subpage({Key? key}) : super(key: key);

  @override
  State<Subpage> createState() => _SubpageState();
}

class _SubpageState extends State<Subpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Router.of(context).routerDelegate.popRoute();
          },
          child: const Text('返回'),
        ),
      ),
    );
  }
}
