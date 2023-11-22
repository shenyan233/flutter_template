import 'package:flutter/material.dart';

class SubpageArgs extends StatefulWidget {
  final String message;

  SubpageArgs({Key? key, required args})
      : message = args['message'],
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
            Text(widget.message),
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
