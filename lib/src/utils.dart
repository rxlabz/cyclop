import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//bool get isPhoneScreen => !(screenSize.shortestSide >= 600);

extension CyclopScreen on MediaQueryData {
  bool get isPhone => size.shortestSide < 600;
}

extension CyclopChroma on String {
  /// converts string to [Color]
  /// fill incomplete values with 0
  /// ex: 'ff00'.toColor() => Color(0xffff0000)
  Color toColor({bool argb = false}) {
    final colorString = '0x${argb ? '' : 'ff'}$this'.padRight(10, '0');
    return Color(int.tryParse(colorString) ?? 0);
  }
}

/// shortcuts to manipulate [Color]
extension CyclopColorUtils on Color {
  HSLColor get hsl => HSLColor.fromColor(this);

  double get hue => hsl.hue;

  double get saturation => hsl.saturation;

  double get lightness => hsl.lightness;

  Color withHue(double value) => hsl.withHue(value).toColor();

  /// ff001232
  String get hexARGB => toARGB32().toRadixString(16).padLeft(8, '0');

  /// 001232ac
  String get hexRGB =>
      toARGB32().toRadixString(16).padLeft(8, '0').replaceRange(0, 2, '');

  Color withSaturation(double value) =>
      HSLColor.fromAHSL(a, hue, value, lightness).toColor();

  Color withLightness(double value) => hsl.withLightness(value).toColor();

  /// generate the gradient of a color with
  /// lightness from 0 to 1 in [stepCount] steps
  List<Color> getShades(int stepCount, {bool skipFirst = true}) =>
      List.generate(
        stepCount,
        (index) {
          return hsl
              .withLightness(1 -
                  ((index + (skipFirst ? 1 : 0)) /
                      (stepCount - (skipFirst ? -1 : 1))))
              .toColor();
        },
      );
}

extension CyclopColorListUtils on List<Color> {
  /// return the central item of a color list or black if the list is empty
  Color get center => isEmpty ? Colors.black : this[length ~/ 2];
}

List<Color> getHueGradientColors({double? saturation, int steps = 36}) =>
    List.generate(steps, (value) => value)
        .map<Color>((v) {
          final hsl = HSLColor.fromAHSL(1, v * (360 / steps), 0.67, 0.50);
          final rgb = hsl.toColor();
          return rgb.withValues(alpha: 1);
        })
        .map((c) => saturation != null ? c.withSaturation(saturation) : c)
        .toList();

const samplingGridSize = 9;

class ImageSnapshot {
  final Uint8List bytes;
  final int width;
  final int height;

  const ImageSnapshot({
    required this.bytes,
    required this.width,
    required this.height,
  });

  factory ImageSnapshot.fromByteData(
    ByteData byteData, {
    required int width,
    required int height,
  }) =>
      ImageSnapshot(
        bytes: byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
        width: width,
        height: height,
      );

  Color getPixel(int x, int y) {
    if (x < 0 || y < 0 || x >= width || y >= height) {
      return const Color(0x00000000);
    }
    final offset = (y * width + x) * 4;
    return Color.fromARGB(
      bytes[offset + 3],
      bytes[offset],
      bytes[offset + 1],
      bytes[offset + 2],
    );
  }
}

List<Color> getPixelColors(
  ImageSnapshot image,
  Offset offset, {
  int size = samplingGridSize,
}) {
  final halfSize = (size ~/ 2).toDouble();
  final origin = offset - Offset(halfSize, halfSize);
  return List.generate(
    size * size,
    (index) => getPixelColor(
      image,
      origin + _offsetFromIndex(index, size),
    ),
  );
}

Color getPixelColor(ImageSnapshot image, Offset offset) =>
    image.getPixel(offset.dx.toInt(), offset.dy.toInt());

ui.Offset _offsetFromIndex(int index, int numColumns) => Offset(
      (index % numColumns).toDouble(),
      ((index ~/ numColumns) % numColumns).toDouble(),
    );

Color abgr2Color(int value) {
  final a = (value >> 24) & 0xFF;
  final b = (value >> 16) & 0xFF;
  final g = (value >> 8) & 0xFF;
  final r = (value >> 0) & 0xFF;

  return Color.fromARGB(a, r, g, b);
}

Future<ImageSnapshot?> repaintBoundaryToImage(
  RenderRepaintBoundary renderer,
) async {
  try {
    final rawImage = await renderer.toImage(pixelRatio: 1);
    final byteData =
        await rawImage.toByteData(format: ui.ImageByteFormat.rawStraightRgba);

    if (byteData == null) throw Exception('Null image byteData !');

    return ImageSnapshot.fromByteData(
      byteData,
      width: rawImage.width,
      height: rawImage.height,
    );
  } catch (err, stackTrace) {
    debugPrint('repaintBoundaryToImage... $err $stackTrace');

    rethrow;
  }
}
