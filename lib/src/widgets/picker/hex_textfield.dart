import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils.dart';

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
  static const _width = 106.0;

  Color color;

  TextEditingController _controller;

  String prefix;

  @override
  void initState() {
    super.initState();
    prefix = '#${widget.withAlpha ? '' : 'ff'}';

    String colorValue = _initColorValue();
    _controller = TextEditingController(text: colorValue);
  }

  @override
  void didUpdateWidget(HexColorField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      String colorValue = _initColorValue();
      _controller.text = colorValue;
    }
  }

  String _initColorValue() {
    color = widget.color;
    var stringValue = color.value.toRadixString(16).padLeft(8, '0');
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
          style: textTheme.bodyText1.copyWith(fontSize: 15),
          maxLines: 1,
          inputFormatters: [
            WhitelistingTextInputFormatter(RegExp('[A-Fa-f0-9]')),
          ],
          maxLength: widget.withAlpha ? 8 : 6,
          onSubmitted: (value) => widget.onColorChanged(value.toColor()),
          decoration: InputDecoration(
            prefixText: prefix,
            counterText: '',
          ),
        ),
      ),
    );
  }
}
