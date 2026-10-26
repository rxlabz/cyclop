import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class OpacitySliderTrack extends SliderTrackShape with BaseSliderTrackShape {
  final Color selectedColor;

  static const _cellSize = 10.0;

  static final _whitePaint = Paint()..color = Colors.white;
  static final _greyPaint = Paint()..color = const Color(0xffb4b4b4);

  const OpacitySliderTrack(this.selectedColor);

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
    Offset? secondaryOffset,
  }) {
    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final trackRadius = Radius.circular(trackRect.height / 2);
    final activeTrackRadius = Radius.circular(trackRect.height / 2 + 1);

    final activePaint = Paint()..color = Colors.transparent;

    final inactivePaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(trackRect.width, 0),
        [selectedColor.withValues(alpha: 0), selectedColor.withValues(alpha: 1)],
        [0.05, 0.95],
      );

    Paint leftTrackPaint;
    Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    const thumbRadius = 14;

    final shapeRect = RRect.fromLTRBAndCorners(
      trackRect.left - thumbRadius,
      (textDirection == TextDirection.ltr)
          ? trackRect.top - (additionalActiveTrackHeight / 2)
          : trackRect.top,
      trackRect.right + thumbRadius,
      (textDirection == TextDirection.ltr)
          ? trackRect.bottom + (additionalActiveTrackHeight / 2)
          : trackRect.bottom,
      topLeft: (textDirection == TextDirection.ltr)
          ? activeTrackRadius
          : trackRadius,
      bottomLeft: (textDirection == TextDirection.ltr)
          ? activeTrackRadius
          : trackRadius,
      topRight: (textDirection == TextDirection.ltr)
          ? activeTrackRadius
          : trackRadius,
      bottomRight: (textDirection == TextDirection.ltr)
          ? activeTrackRadius
          : trackRadius,
    );

    context.canvas.drawRRect(shapeRect, leftTrackPaint);
    _paintCheckerboard(context.canvas, shapeRect);
    context.canvas.drawRRect(shapeRect, rightTrackPaint);
  }

  void _paintCheckerboard(Canvas canvas, RRect shapeRect) {
    final bounds = shapeRect.outerRect;
    canvas.save();
    canvas.clipRRect(shapeRect);
    canvas.drawRect(bounds, _whitePaint);

    final cols = (bounds.width / _cellSize).ceil();
    final rows = (bounds.height / _cellSize).ceil();

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        if ((row + col).isOdd) {
          canvas.drawRect(
            Rect.fromLTWH(
              bounds.left + col * _cellSize,
              bounds.top + row * _cellSize,
              _cellSize,
              _cellSize,
            ),
            _greyPaint,
          );
        }
      }
    }
    canvas.restore();
  }
}
