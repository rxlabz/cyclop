import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

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
      final image = img.Image(width: 15, height: 15);
      image.setPixelRgba(7, 7, 255, 0, 0, 255);

      final colors = getPixelColors(image, const Offset(7, 7));
      expect(colors.length, 81);
      // Center element for 9x9 grid is index 40
      expect(colors[40], const Color(0xffff0000));
    });

    test('respects custom grid size parameter and centers appropriately', () {
      final image = img.Image(width: 10, height: 10);
      image.setPixelRgba(4, 4, 0, 255, 0, 255);

      final colors = getPixelColors(image, const Offset(4, 4), size: 3);
      expect(colors.length, 9);
      // Center element for 3x3 grid is index 4
      expect(colors[4], const Color(0xff00ff00));
    });
  });
}
