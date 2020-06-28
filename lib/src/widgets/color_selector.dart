import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extensions.dart';

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

  //final style = TextStyle(fontSize: 12, color: Colors.black);

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
            onColorChanged: onColorChanged,
          ),
          IconButton(icon: Icon(Icons.colorize), onPressed: onEyePick),
        ],
      ),
    );
  }
}

class HexColorField extends StatefulWidget {
  final bool withAlpha;

  final Color color;

  final ValueChanged<Color> onColorChanged;

  const HexColorField({
    Key key,
    @required this.withAlpha,
    @required this.color,
    @required this.onColorChanged,
  }) : super(key: key);

  @override
  _HexColorFieldState createState() => _HexColorFieldState();
}

class _HexColorFieldState extends State<HexColorField> {
  Color color;

  TextEditingController _controller;

  String prefix;

  @override
  void initState() {
    prefix = '#${widget.withAlpha ? '' : 'FF'}';

    color = widget.color ?? Colors.black;
    String stringValue = color.value.toRadixString(16).padLeft(8, '0');
    if (!widget.withAlpha) stringValue = stringValue.replaceRange(0, 2, '');

    _controller = TextEditingController(text: stringValue);

    super.initState();
  }

  @override
  void didUpdateWidget(HexColorField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      color = widget.color;
      String stringValue = color.value.toRadixString(16).padLeft(8, '0');
      if (!widget.withAlpha) stringValue = stringValue.replaceRange(0, 2, '');
      _controller.text = stringValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(prefix, style: textTheme.bodyText1),
          SizedBox(
            width: 80,
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              style: textTheme.bodyText1,
              maxLines: 1,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[A-Fa-f0-9]')),
              ],
              maxLength: widget.withAlpha ? 8 : 6,
              onChanged: (newValue) => widget.onColorChanged(newValue.toColor())
              /*setState(() => color = newValue.toColor())*/,
              decoration: InputDecoration(
                isDense: true,
                filled: false,
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
