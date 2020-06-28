import 'package:flutter/material.dart';
import 'package:paco/src/widgets/color_selector.dart';

class ColorPreview extends StatelessWidget {
  final Color selectedColor;

  const ColorPreview({Key key, @required this.selectedColor}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(color: selectedColor, width: 96, height: 48),
          ColorSelector(color: selectedColor, withAlpha: true),
        ],
      );
}
