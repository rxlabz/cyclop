import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../theme.dart';
import 'color_picker.dart';
import '../utils.dart';
import 'eyedrop/eye_dropper_layer.dart';

const _buttonSize = 48.0;

class ColorButton extends StatefulWidget {
  final Color color;
  final double size;
  final BoxDecoration decoration;
  final BoxShape boxShape;
  final ColorPickerConfig config;
  final Set<Color> swatches;

  final ValueChanged<Color> onColorChanged;

  final ValueChanged<Set<Color>> onSwatchesChanged;

  final bool darkMode;

  const ColorButton({
    Key key,
    @required this.color,
    @required this.onColorChanged,
    this.config = const ColorPickerConfig(),
    this.darkMode = false,
    this.size = _buttonSize,
    this.decoration,
    this.boxShape = BoxShape.circle,
    this.swatches = const {},
    this.onSwatchesChanged,
  })  : assert(boxShape != null || decoration != null),
        super(key: key);

  @override
  _ColorButtonState createState() => _ColorButtonState();
}

class _ColorButtonState extends State<ColorButton> {
  OverlayEntry pickerOverlay;

  Color color;

  // hide the palette dureting eyedropping
  bool hidden = false;

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
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (details) => _colorPick(context, details),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: widget.decoration ??
              BoxDecoration(
                shape: widget.boxShape,
                color: widget.color,
                border: Border.all(width: 4, color: Colors.white),
                boxShadow: darkShadowBox,
              ),
        ),
      );

  void _colorPick(BuildContext context, TapDownDetails details) async {
    final selectedColor =
        await showColorPicker(context, details.globalPosition);
    widget.onColorChanged(selectedColor);
  }

  Future<Color> showColorPicker(BuildContext rootContext, Offset offset) async {
    if (pickerOverlay != null) return Future.value(widget.color);

    pickerOverlay = _buildPickerOverlay(offset, rootContext);

    Overlay.of(rootContext).insert(pickerOverlay);

    return Future.value(widget.color);
  }

  OverlayEntry _buildPickerOverlay(Offset offset, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final left = offset.dx + pickerWidth < size.width - 30
        ? offset.dx + _buttonSize
        : offset.dx - pickerWidth - _buttonSize;
    final top = offset.dy - pickerHeight / 2 > 0
        ? min(offset.dy - pickerHeight / 2, size.height - pickerHeight - 50)
        : 50.0;

    return OverlayEntry(
      maintainState: true,
      builder: (c) => Positioned(
        left: isPhoneScreen ? (size.width - pickerWidth) / 2 : left,
        top: isPhoneScreen ? (size.height - pickerHeight) / 2 : top,
        child: IgnorePointer(
          ignoring: hidden,
          child: Opacity(
            opacity: hidden ? 0 : 1,
            child: Material(
              borderRadius: BorderRadius.circular(8),
              child: ColorPicker(
                darkMode: widget.darkMode,
                config: widget.config,
                selectedColor: color,
                swatches: widget.swatches,
                onClose: () {
                  pickerOverlay.remove();
                  pickerOverlay = null;
                },
                onColorSelected: (c) {
                  color = c ?? color;
                  pickerOverlay.markNeedsBuild();
                  widget.onColorChanged(c ?? color);
                },
                onSwatchesUpdate: widget.onSwatchesChanged,
                onEyeDropper: () {
                  hidden = true;
                  try {
                    EyeDrop.of(context).capture(context, (value) {
                      hidden = false;
                      _onEyePick(value);
                    });
                  } catch (err) {
                    print('ERROR !!! _buildPickerOverlay $err');
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onEyePick(Color value) {
    color = value;
    widget.onColorChanged(value);
    pickerOverlay?.markNeedsBuild();
  }
}
