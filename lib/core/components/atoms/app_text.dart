import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;

  final TextStyle? style;

  final Color? color;

  final double? fontSize;

  final FontWeight? fontWeight;

  final TextAlign? textAlign;

  final int? maxLines;

  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyMedium!;

    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: defaultStyle
          .copyWith(color: color, fontSize: fontSize, fontWeight: fontWeight)
          .merge(style),
    );
  }
}
