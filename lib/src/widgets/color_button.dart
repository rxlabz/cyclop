import 'package:flutter/material.dart';

import '../theme.dart';
import '../color_picker.dart';
import 'eye_dropper_layer.dart';

class ColorButton extends StatefulWidget {
  final Color color;

  final ValueChanged<Color> onColorChanged;

  final bool darkMode;

  const ColorButton({
    Key key,
    @required this.color,
    @required this.onColorChanged,
    this.darkMode = false,
  }) : super(key: key);

  @override
  _ColorButtonState createState() => _ColorButtonState();
}

class _ColorButtonState extends State<ColorButton> {
  OverlayEntry pickerOverlay;

  Color color;

  @override
  void initState() {
    super.initState();
    color = widget.color;
  }

  @override
  void didUpdateWidget(ColorButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => colorPick(context, details),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
          border: Border.all(width: 4, color: Colors.white),
          boxShadow: darkShadowBox,
        ),
      ),
    );
  }

  void colorPick(BuildContext context, TapDownDetails details) async {
    final selectedColor = await showPaco(context, details.globalPosition);
    widget.onColorChanged(selectedColor);
  }

  Future<Color> showPaco(BuildContext context, Offset offset) {
    if (pickerOverlay != null) return Future.value(widget.color);

    pickerOverlay = _buildPickerOverlay(offset, context);

    Overlay.of(context).insert(pickerOverlay);

    return Future.value(widget.color);
  }

  OverlayEntry _buildPickerOverlay(Offset offset, BuildContext context) {
    return OverlayEntry(
      maintainState: true,
      builder: (c) => Positioned(
        left: offset.dx + 60,
        top: offset.dy - 250,
        child: Material(
          borderRadius: BorderRadius.circular(8),
          child: ColorPicker(
            darkMode: widget.darkMode,
            config: ColorPickerConfig(),
            selectedColor: color,
            onClose: () {
              pickerOverlay.remove();
              pickerOverlay = null;
            },
            onColorSelected: (c) {
              color = c;
              pickerOverlay.markNeedsBuild();
              widget.onColorChanged(c);
            },
            onEyeDropper: () =>
                EyeDropperLayer.of(context).capture(context, _onEyePick),
          ),
        ),
      ),
    );
  }

  void _onEyePick(Color value) {
    color = value;
    pickerOverlay.markNeedsBuild();
    widget.onColorChanged(value);
  }
}
