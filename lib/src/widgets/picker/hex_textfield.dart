import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils.dart';

class HexColorField extends StatefulWidget {
  final bool withAlpha;

  final Color color;

  final FocusNode hexFocus;

  final ValueChanged<Color> onColorChanged;

  const HexColorField({
    required this.withAlpha,
    required this.color,
    required this.onColorChanged,
    required this.hexFocus,
    super.key,
  });

  @override
  HexColorFieldState createState() => HexColorFieldState();
}

class HexColorFieldState extends State<HexColorField> {
  static const _width = 106.0;

  late Color color;

  late TextEditingController _controller;

  late String prefix;

  int valueLength = 8;

  @override
  void initState() {
    super.initState();
    _initFormat();

    final colorHexValue =
        widget.withAlpha ? widget.color.hexARGB : widget.color.hexRGB;
    _controller = TextEditingController(text: colorHexValue);
    widget.hexFocus.addListener(_onFocusChange);
  }

  void _initFormat() {
    prefix = '#${widget.withAlpha ? '' : 'ff'}';
    valueLength = widget.withAlpha ? 8 : 6;
  }

  void _onFocusChange() {
    if (!widget.hexFocus.hasFocus) {
      _submitHex(_controller.text);
    }
  }

  void _submitHex(String value) {
    if (value.isEmpty) return;
    final newColor =
        value.padRight(valueLength, '0').toColor(argb: widget.withAlpha);
    if (newColor != widget.color) {
      widget.onColorChanged(newColor);
    }
  }

  @override
  void didUpdateWidget(HexColorField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hexFocus != widget.hexFocus) {
      oldWidget.hexFocus.removeListener(_onFocusChange);
      widget.hexFocus.addListener(_onFocusChange);
    }
    if (oldWidget.withAlpha != widget.withAlpha) {
      _initFormat();
    }
    if (oldWidget.color != widget.color ||
        oldWidget.withAlpha != widget.withAlpha) {
      final colorHexValue =
          widget.withAlpha ? widget.color.hexARGB : widget.color.hexRGB;
      _controller.text = colorHexValue;

      if (widget.hexFocus.hasFocus) widget.hexFocus.nextFocus();
    }
  }

  @override
  void dispose() {
    widget.hexFocus.removeListener(_onFocusChange);
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
          style: textTheme.bodyMedium,
          maxLines: 1,
          autocorrect: false,
          enableSuggestions: false,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[A-Fa-f0-9]')),
          ],
          maxLength: valueLength,
          onSubmitted: _submitHex,
          decoration: InputDecoration(
            prefixText: prefix,
            counterText: '',
          ),
        ),
      ),
    );
  }
}
