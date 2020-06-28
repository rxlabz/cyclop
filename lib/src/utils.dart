import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;

extension Chroma on String {
  Color toColor({bool argb = false}) {
    final colorString =
        '0x${argb ? '' : 'ff'}$this'.padRight(argb ? 10 : 8, '0');
    return Color(int.tryParse(colorString) ?? 0);
  }
}

extension Utils on Color {
  HSLColor get hsl => HSLColor.fromColor(this);

  List<Color> getShades(int stepCount, {bool skipFirst = true}) =>
      List.generate(
          stepCount,
          (index) => hsl
              .withLightness(1 -
                  ((index + (skipFirst ? 1 : 0)) /
                      (stepCount - (skipFirst ? -1 : 1))))
              .toColor());
}

const samplingGridSize = 5;

Color getPixelColor(img.Image image, Offset offset) => (offset.dx >= 0 &&
        offset.dy >= 0 &&
        offset.dx < image.width &&
        offset.dy < image.height)
    ? ABGR2Color(image.getPixel(offset.dx.toInt(), offset.dy.toInt()))
    : Color(0);

List<Color> getPixelColors(img.Image image, Offset offset) => List.generate(
    25, (index) => getPixelColor(image, offset + _offsetFromIndex(index, 5)));

ui.Offset _offsetFromIndex(int index, int numColumns) => Offset(
    (index % numColumns).toDouble(),
    ((index ~/ numColumns) % numColumns).toDouble());

Color ABGR2Color(int value) {
  final a = (value >> 24) & 0xFF;
  final b = (value >> 16) & 0xFF;
  final g = (value >> 8) & 0xFF;
  final r = (value >> 0) & 0xFF;

  return Color.fromARGB(a, r, g, b);
}

Future<img.Image> repaintBoundaryToImage(RenderRepaintBoundary renderer) async {
  final rawImage = await renderer.toImage(pixelRatio: 1);
  final byteData =
      await rawImage.toByteData(format: ui.ImageByteFormat.rawRgba);
  final pngBytes = byteData.buffer.asUint8List();
  return img.Image.fromBytes(rawImage.width, rawImage.height, pngBytes);
}
