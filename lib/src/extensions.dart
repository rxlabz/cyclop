import 'dart:ui';

extension Chroma on String {
  Color toColor({bool argb: false}) {
    final colorString =
        '0x${argb ? '' : 'ff'}$this'.padRight(argb ? 10 : 8, '0');
    return Color(int.tryParse(colorString) ?? 0);
  }
}
