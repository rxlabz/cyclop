import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils.dart';

class HexColorField extends StatefulWidget {
  final bool withAlpha;

  final Color color;

  final FocusNode hexFocus;

  final ValueChanged<Color> onColorChanged;

  const HexColorField({
    Key key,
    @required this.withAlpha,
    @required this.color,
    @required this.onColorChanged,
    @required this.hexFocus,
  }) : super(key: key);

  @override
  _HexColorFieldState createState() => _HexColorFieldState();
}

class _HexColorFieldState extends State<HexColorField> {
  static const _width = 106.0;

  Color color;

  TextEditingController _controller;

  String prefix;

  int valueLength = 8;

  @override
  void initState() {
    super.initState();
    prefix = '#${widget.withAlpha ? '' : 'ff'}';

    valueLength = widget.withAlpha ? 8 : 6;

    String colorValue = _initColorValue();
    _controller = TextEditingController(text: colorValue);
  }

  @override
  void didUpdateWidget(HexColorField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      String colorValue = _initColorValue();
      _controller.text = colorValue;

      if (widget.hexFocus.hasFocus) widget.hexFocus.nextFocus();
    }
  }

  String _initColorValue() {
    color = widget.color;
    var stringValue = color.value.toRadixString(16).padRight(8, '0');
    if (!widget.withAlpha) stringValue = stringValue.replaceRange(0, 2, '');
    return stringValue;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SizedBox(
        width: _width,
        child: TextField(
          controller: _controller,
          focusNode: widget.hexFocus,
          style: textTheme.bodyText1.copyWith(fontSize: 15),
          maxLines: 1,
          autocorrect: false,
          autofillHints: [],
          inputFormatters: [
            // ignore: deprecated_member_use
            WhitelistingTextInputFormatter(RegExp('[A-Fa-f0-9]')),
            // TODO Flutter 1.20.1
            //FilteringTextInputFormatter.allow(RegExp('[A-Fa-f0-9]')),
          ],
          maxLength: valueLength,
          onSubmitted: (value) => widget.onColorChanged(
            value.padRight(valueLength, '0').toColor(argb: widget.withAlpha),
          ),
          decoration: InputDecoration(
            prefixText: prefix,
            counterText: '',
          ),
        ),
      ),
    );
  }
}
