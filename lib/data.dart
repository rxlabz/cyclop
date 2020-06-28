import 'package:flutter/material.dart';

class Labels {
  static const String mainTitle = 'Colors';
  static const String opacity = 'Opacity';
}

const shadowColor = Color(0x44333333);
final defaultShadowBox = [
  BoxShadow(
    blurRadius: 3,
    spreadRadius: 1,
    color: shadowColor,
  )
];

final lightTheme = ThemeData.light().copyWith(
    backgroundColor: Color(0xffe9e9e9),
    toggleableActiveColor: Colors.white,
    dialogTheme: ThemeData.light().dialogTheme.copyWith(
          backgroundColor: Color(0xfff6f6f6),
        ),
    iconTheme: ThemeData.light().iconTheme.copyWith(color: Colors.blue)
    /*buttonTheme:
      ThemeData.light().buttonTheme.copyWith(textTheme: ButtonTextTheme.accent),*/
    );

final darkTheme = ThemeData.dark().copyWith(
  backgroundColor: Colors.grey.shade700,
  toggleableActiveColor: Colors.grey.shade800,
  dialogTheme: ThemeData.light().dialogTheme.copyWith(
        backgroundColor: Colors.grey.shade800,
      ),
);
