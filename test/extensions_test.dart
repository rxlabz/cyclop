import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:cyclop/cyclop.dart';

void main() {
  group('Color on String', () {
    //setUp((){});

    test('toColor correctly fill to hexa value RGB', () {
      final color = ''.toColor();
      expect(color, const Color(0xff000000));

      final color2 = ''.toColor(argb: false);
      expect(color2, const Color(0xff000000));

      final color3 = 'ff0000'.toColor(argb: false);
      expect(color3, const Color(0xffff0000));
    });

    test('toColor correctly fill to hexa value ARGB', () {
      final color = ''.toColor(argb: true);
      expect(color, const Color(0x00000000));

      final color2 = 'ff0000'.toColor(argb: true);
      expect(color2, const Color(0xff000000));

      final color3 = 'aaff0000'.toColor(argb: true);
      expect(color3, const Color(0xaaff0000));

      final color4 = 'aaff00'.toColor(argb: true);
      expect(color4, const Color(0xaaff0000));
    });
  });

  group('getPixelColors', () {
    test('centers sampling grid around target offset', () {
      final bytes = Uint8List(15 * 15 * 4);
      // set pixel at (7, 7) to red (r: 255, g: 0, b: 0, a: 255)
      final offset = (7 * 15 + 7) * 4;
      bytes[offset] = 255;
      bytes[offset + 1] = 0;
      bytes[offset + 2] = 0;
      bytes[offset + 3] = 255;

      final image = ImageSnapshot(bytes: bytes, width: 15, height: 15);
      final colors = getPixelColors(image, const Offset(7, 7));
      expect(colors.length, 81);
      // Center element for 9x9 grid is index 40
      expect(colors[40], const Color(0xffff0000));
    });

    test('respects custom grid size parameter and centers appropriately', () {
      final bytes = Uint8List(10 * 10 * 4);
      // set pixel at (4, 4) to green (r: 0, g: 255, b: 0, a: 255)
      final offset = (4 * 10 + 4) * 4;
      bytes[offset] = 0;
      bytes[offset + 1] = 255;
      bytes[offset + 2] = 0;
      bytes[offset + 3] = 255;

      final image = ImageSnapshot(bytes: bytes, width: 10, height: 10);
      final colors = getPixelColors(image, const Offset(4, 4), size: 3);
      expect(colors.length, 9);
      // Center element for 3x3 grid is index 4
      expect(colors[4], const Color(0xff00ff00));
    });
  });
}
