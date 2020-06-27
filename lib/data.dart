import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

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

final darkTheme = ThemeData.dark().copyWith(
  backgroundColor: Colors.grey.shade700,
  toggleableActiveColor: Colors.grey.shade800,
);
