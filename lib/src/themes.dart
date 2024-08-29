import 'package:flutter/material.dart';

class AppThemes {
  Color primary = const Color.fromARGB(255, 1, 61, 101);
  Color secondary = const Color.fromARGB(255, 0, 115, 198);
  Color tertiary = const Color.fromARGB(255, 106, 156, 60);
  Color background = const Color(0xFFFFFFFF);
  Color whiteInputs = const Color(0xFFF2F2F2);
  Color negative = const Color(0xFFDA0000);
  Color negativeNumber = const Color(0xFFC43D03);
  Color notSelected = const Color(0xFF898989);
  Color orange = const Color(0xFFFF8744);
  Color green = const Color(0xFF6B9C3C);
  Color gold = const Color(0xFFFAC155);

  Color white = const Color(0xFFFFFFFF);
  Color black = const Color(0xFF000000);
  Color grey = const Color.fromARGB(255, 158, 156, 156);

  Color myBizne = const Color(0xEEEEEEEE);

  ThemeData get theme {
    return ThemeData(
      buttonTheme: ButtonThemeData(buttonColor: primary),
      colorScheme: ColorScheme.light(primary: primary),
      primaryColor: primary,
      fontFamily: 'Quicksand',
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      buttonTheme: ButtonThemeData(buttonColor: primary),
      colorScheme: ColorScheme.dark(primary: primary),
      primaryColor: primary,
      fontFamily: 'Quicksand',
    );
  }

  BorderRadius get borderRadius => BorderRadius.circular(19);
}
