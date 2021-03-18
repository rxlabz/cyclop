import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:cyclop/cyclop.dart';

void main() {
  group('Color on String', () {
    //setUp((){});

    test('toColor correctly fill to hexa value RGB', () {
      final color = ''.toColor();
      expect(color, Color(0xff000000));

      final color2 = ''.toColor(argb: false);
      expect(color2, Color(0xff000000));

      final color3 = 'ff0000'.toColor(argb: false);
      expect(color3, Color(0xffff0000));
    });

    test('toColor correctly fill to hexa value ARGB', () {
      final color = ''.toColor(argb: true);
      expect(color, Color(0x00000000));

      final color2 = 'ff0000'.toColor(argb: true);
      expect(color2, Color(0xff000000));

      final color3 = 'aaff0000'.toColor(argb: true);
      expect(color3, Color(0xaaff0000));

      final color4 = 'aaff00'.toColor(argb: true);
      expect(color4, Color(0xaaff0000));
    });
  });
}
