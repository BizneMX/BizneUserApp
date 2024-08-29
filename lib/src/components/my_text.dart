import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../environment.dart';

enum FontType { regular, bold, medium, semibold, light }

enum FontFamily { quicksand, openSans, montserrat, rajdhani }

class FontTypeWeight {
  static FontWeight getFontType(FontType type) {
    switch (type) {
      case FontType.regular:
        return FontWeight.normal;
      case FontType.light:
        return FontWeight.w300;
      case FontType.medium:
        return FontWeight.w500;
      case FontType.semibold:
        return FontWeight.w700;
      case FontType.bold:
        return FontWeight.w900;
      default:
        return FontWeight.normal;
    }
  }
}

class Font {
  static String getFontFamily(FontFamily fontFamily) {
    switch (fontFamily) {
      case FontFamily.openSans:
        return 'Open Sans';
      case FontFamily.montserrat:
        return 'Montserrat';
      case FontFamily.quicksand:
        return 'Quicksand';
      case FontFamily.rajdhani:
        return 'Rajdhani';
      default:
        return 'Quicksand';
    }
  }
}

class MyText extends StatelessWidget {
  final String text;
  final FontFamily fontFamily;
  final FontType type;
  final double fontSize;
  final Color? color;
  final TextAlign align;
  final TextDecoration decoration;
  final TextDecorationStyle? decorationStyle;
  final int? maxLines;
  final bool? softWrap;
  final TextOverflow? overflow;

  const MyText(
      {super.key,
      required this.text,
      this.fontFamily = FontFamily.quicksand,
      this.type = FontType.regular,
      this.fontSize = 14.0,
      this.color,
      this.align = TextAlign.left,
      this.decoration = TextDecoration.none,
      this.decorationStyle,
      this.maxLines,
      this.softWrap,
      this.overflow});

  @override
  Widget build(BuildContext context) {
    return Text(
        textScaler: TextScaler.linear(Device().isMobile() ? 0.9 : 1.4),
        text,
        textAlign: align,
        maxLines: maxLines,
        style: TextStyle(
            fontFamily: Font.getFontFamily(fontFamily),
            fontSize: fontSize,
            color: color,
            fontWeight: FontTypeWeight.getFontType(type),
            decoration: decoration,
            decorationColor: color,
            fontFamilyFallback: <String>[Font.getFontFamily(fontFamily)]));
  }
}

class MyTextSpan extends TextSpan {
  MyTextSpan(
      {super.text,
      FontFamily fontFamily = FontFamily.quicksand,
      FontType type = FontType.regular,
      double fontSize = 14.0,
      Color? color,
      TextAlign align = TextAlign.left,
      TextDecoration decoration = TextDecoration.none,
      TextDecorationStyle? decorationStyle,
      int? maxLines,
      bool? softWrap,
      TextOverflow? overflow,
      TapGestureRecognizer? super.recognizer,
      List<MyTextSpan>? super.children})
      : super(
            style: TextStyle(
                fontFamily: Font.getFontFamily(fontFamily),
                fontSize: fontSize,
                color: color ?? AppThemes().black,
                fontWeight: FontTypeWeight.getFontType(type),
                decoration: decoration,
                decorationStyle: decorationStyle,
                fontFamilyFallback: <String>[Font.getFontFamily(fontFamily)]));
}

class MyRichText extends StatelessWidget {
  final MyTextSpan text;
  final TextAlign align;
  final int? maxLines;
  final bool softWrap;
  final TextOverflow overflow;

  const MyRichText(
      {super.key,
      this.align = TextAlign.left,
      this.maxLines,
      this.softWrap = true,
      this.overflow = TextOverflow.clip,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: text,
      textAlign: align,
      maxLines: maxLines,
      softWrap: softWrap,
      overflow: overflow,
    );
  }
}
