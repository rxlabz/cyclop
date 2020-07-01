import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

const _cellSize = 20;

const _gridSize = 100.0;

class EyeDropOverlay extends StatelessWidget {
  final Offset cursorPosition;
  final bool touchable;

  final Color color;
  final List<Color> colors;

  final ValueChanged<Color> onTap;

  const EyeDropOverlay({
    Key key,
    this.cursorPosition,
    this.color,
    this.onTap,
    this.colors,
    this.touchable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return cursorPosition != null
        ? Positioned(
            left: cursorPosition.dx - (_gridSize / 2),
            top: cursorPosition.dy -
                (_gridSize / 2) -
                (touchable ? _gridSize / 2 : 0),
            width: _gridSize,
            height: _gridSize,
            child: _buildZoom(),
          )
        : SizedBox();
  }

  Widget _buildZoom() {
    return IgnorePointer(
      ignoring: true,
      child: Container(
        foregroundDecoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              width: 8, color: colors.isEmpty ? Colors.white : colors[12]),
        ),
        child: ClipOval(
          child: CustomPaint(
            size: Size(_gridSize, _gridSize),
            painter: _PixelGridPainter(colors),
          ),
        ),
        width: _gridSize,
        height: _gridSize,
        constraints: BoxConstraints.loose(Size(_gridSize, _gridSize)),
      ),
    );
  }
}

class _PixelGridPainter extends CustomPainter {
  final List<Color> colors;

  static const gridSize = 5;
  static const eyeRadius = 40.0;

  final blackStroke = Paint()
    ..color = Colors.black
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke;

  _PixelGridPainter(this.colors);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke;

    final selectedStroke = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (final color in enumerate(colors)) {
      final fill = Paint()..color = color.value;
      final rect = Rect.fromLTWH(
        (color.index % gridSize).toDouble() * _cellSize,
        ((color.index ~/ gridSize) % gridSize).toDouble() * _cellSize,
        _cellSize.toDouble(),
        _cellSize.toDouble(),
      );
      canvas.drawRect(rect, fill);
      canvas.drawRect(rect, color.index == 12 ? selectedStroke : stroke);
    }

    canvas.drawCircle(
        Offset((_gridSize) / 2, (_gridSize) / 2), eyeRadius, blackStroke);
  }

  @override
  bool shouldRepaint(_PixelGridPainter oldDelegate) =>
      !listEquals(oldDelegate.colors, colors);
}
