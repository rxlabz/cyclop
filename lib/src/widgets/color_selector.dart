import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils.dart';
import 'hex_textfield.dart';

class ColorSelector extends StatelessWidget {
  final Color color;
  final bool withAlpha;
  final double thumbWidth;
  final ValueChanged<Color> onColorChanged;
  final VoidCallback onEyePick;

  const ColorSelector({
    Key key,
    this.color,
    this.withAlpha = false,
    this.thumbWidth = 96,
    this.onColorChanged,
    this.onEyePick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(color: color, width: thumbWidth, height: 36),
          HexColorField(
            color: color,
            withAlpha: withAlpha,
            onColorChanged: (value) {
              onColorChanged(value);
            },
          ),
          IconButton(icon: Icon(Icons.colorize), onPressed: onEyePick),
        ],
      ),
    );
  }
}
