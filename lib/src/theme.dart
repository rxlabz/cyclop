import 'package:flutter/material.dart';

class Labels {
  static const String mainTitle = 'Colors';
  static const String opacity = 'Opacity';
  static const String red = 'Red';
  static const String green = 'Green';
  static const String blue = 'Blue';
  static const String hue = 'Hue';
  static const String saturation = 'Saturation';
  static const String light = 'Lightness';
}

const defaultRadius = 8.0;

final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Color(0xfff0f0f0),
    backgroundColor: Color(0xffdadada),
    toggleableActiveColor: Colors.white,
    inputDecorationTheme: ThemeData.light().inputDecorationTheme.copyWith(
          isDense: true,
          fillColor: Colors.white,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(defaultRadius)),
        ),
    dialogTheme: ThemeData.light().dialogTheme.copyWith(
          backgroundColor: Color(0xfff6f6f6),
        ),
    iconTheme: ThemeData.light().iconTheme.copyWith(color: Colors.blue));

final darkTheme = ThemeData.dark().copyWith(
  backgroundColor: Colors.grey.shade700,
  toggleableActiveColor: Colors.grey.shade800,
  textSelectionColor: Colors.cyan.shade700,
  dialogTheme: ThemeData.light().dialogTheme.copyWith(
        backgroundColor: Colors.grey.shade800,
      ),
  inputDecorationTheme:
      lightTheme.inputDecorationTheme.copyWith(fillColor: Colors.grey.shade800),
);

const defaultDivider = Divider(
  color: Color(0xff999999),
  indent: 8,
  height: 10,
  endIndent: 8,
);

const shadowColor = Color(0x44333333);

const darkShadowColor = Color(0x99333333);

final defaultShadowBox = [
  BoxShadow(
    blurRadius: 3,
    spreadRadius: 1,
    color: shadowColor,
  )
];

final darkShadowBox = [
  BoxShadow(
    blurRadius: 3,
    spreadRadius: 1,
    color: darkShadowColor,
  )
];

final largeDarkShadowBox = [
  BoxShadow(
    blurRadius: 10,
    spreadRadius: 5,
    color: shadowColor,
  )
];
