import 'package:flutter/material.dart';
import '../generated/l10n.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(S.current.errorPage),
      ),
    );
  }
}
