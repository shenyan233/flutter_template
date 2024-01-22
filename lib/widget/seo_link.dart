import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

class SeoLink extends StatelessWidget {
  final String anchor;
  final String href;
  final String? rel;
  final Widget child;

  const SeoLink({
    super.key,
    required this.anchor,
    required this.href,
    this.rel,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Seo.link(
      anchor: anchor,
      href: href,
      rel: rel,
      child: child,
    );
  }
}