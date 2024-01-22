import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

class SeoImage extends StatelessWidget {
  final String alt;
  final String src;

  const SeoImage(
    this.src, {
    super.key,
    required this.alt,
  });

  @override
  Widget build(BuildContext context) {
    return Seo.image(
      alt: alt,
      src: src,
      child: Image.network(src),
    );
  }
}
