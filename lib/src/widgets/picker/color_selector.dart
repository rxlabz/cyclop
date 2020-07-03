import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'hex_textfield.dart';

class ColorSelector extends StatelessWidget {
  final Color color;

  final bool withAlpha;

  final double thumbWidth;

  final FocusNode focus;

  final ValueChanged<Color> onColorChanged;

  final VoidCallback onEyePick;

  final VoidCallback onFieldFocus;

  const ColorSelector({
    Key key,
    this.color,
    @required this.onColorChanged,
    this.onFieldFocus,
    this.onEyePick,
    this.withAlpha = false,
    this.thumbWidth = 96,
    this.focus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildColorThumb(),
          HexColorField(
            hexFocus: focus,
            color: color,
            withAlpha: withAlpha,
            onColorChanged: (value) {
              onColorChanged(value);
            },
          ),
          if (!kIsWeb && onEyePick != null)
            IconButton(icon: Icon(Icons.colorize), onPressed: onEyePick),
        ],
      ),
    );
  }

  Container _buildColorThumb() {
    return Container(
        width: thumbWidth,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              spreadRadius: 1,
              color: Color(0x66101010),
            )
          ],
        ));
  }
}
