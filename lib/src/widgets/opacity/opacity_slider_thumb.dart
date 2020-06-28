import 'dart:math';

import 'package:flutter/material.dart';

class OpacitySliderThumbShape extends RoundSliderThumbShape {
  const OpacitySliderThumbShape(
    this.selectedColor, {
    double enabledThumbRadius = 10.0,
    double disabledThumbRadius,
    double elevation = 1.0,
    double pressedElevation = 3.0,
  }) : super(
          enabledThumbRadius: enabledThumbRadius,
          disabledThumbRadius: disabledThumbRadius,
          elevation: elevation,
          pressedElevation: pressedElevation,
        );

  final Color selectedColor;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    @required Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    @required SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
    double textScaleFactor,
    Size sizeWithOverflow,
  }) {
    assert(context != null);
    assert(center != null);
    assert(enableAnimation != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);
    assert(!sizeWithOverflow.isEmpty);

    final canvas = context.canvas;
    final radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );

    final color = colorTween.evaluate(enableAnimation);
    final radius = radiusTween.evaluate(enableAnimation);

    final elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final evaluatedElevation = elevationTween.evaluate(activationAnimation);

    final path = Path()
      ..addArc(
        Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius),
        0,
        pi * 2,
      );
    canvas.drawShadow(path, Colors.black, evaluatedElevation, true);

    canvas.drawCircle(center, radius, Paint()..color = color);
    canvas.drawCircle(center, radius - 2, Paint()..color = selectedColor);
  }
}
