import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

class SeoText extends StatelessWidget {
  final String text;
  final TextTagStyle? tagStyle;

  final TextStyle? style;

  const SeoText(this.text, {
    super.key,
    this.tagStyle,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Seo.text(
      text: text,
      style: tagStyle ?? TextTagStyle.p,
      child: Text(
        text,
        style: style,
      ),
    );
  }
}

class SeoSelectableText extends StatelessWidget {
  final String text;
  final TextTagStyle? tagStyle;
  final int? maxLines;
  final TextStyle? style;
  final TextAlign? textAlign;
  final GestureTapCallback? onTap;

  const SeoSelectableText(this.text, {
    super.key,
    this.tagStyle,
    this.style,
    this.maxLines,
    this.textAlign,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Seo.text(
      text: text,
      style: tagStyle ?? TextTagStyle.p,
      child: SelectableText(
        text,
        maxLines: maxLines,
        style: style,
        textAlign: textAlign,
        onTap: onTap,
      ),
    );
  }
}