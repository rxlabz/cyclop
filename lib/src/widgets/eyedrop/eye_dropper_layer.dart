import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../utils.dart';
import 'eye_dropper_overlay.dart';

class EyeDropperModel {
  /// based on PointerEvent.kind
  bool touchable = false;

  OverlayEntry? eyeOverlayEntry;

  ImageSnapshot? snapshot;

  Offset? cursorPosition;

  Color hoverColor = Colors.black;

  List<Color> hoverColors = [];

  Color selectedColor = Colors.black;

  ValueChanged<Color>? onColorSelected;

  ValueChanged<Color>? onColorChanged;

  EyeDropperModel();
}

class EyeDrop extends StatefulWidget {
  final Widget child;

  const EyeDrop({required this.child, super.key});

  static EyeDropState of(BuildContext context) {
    final eyeDrop = context.dependOnInheritedWidgetOfExactType<_EyeDropScope>();
    if (eyeDrop == null) {
      throw Exception(
        'No EyeDrop found. You must wrap your application within an EyeDrop widget.',
      );
    }
    return eyeDrop.state;
  }

  @override
  State<EyeDrop> createState() => EyeDropState();
}

class EyeDropState extends State<EyeDrop> {
  final GlobalKey _captureKey = GlobalKey();

  final EyeDropperModel _data = EyeDropperModel();

  bool get _isCapturing => _data.eyeOverlayEntry != null;

  @override
  void dispose() {
    _resetCapture();
    super.dispose();
  }

  void _onPointerUp(Offset position) {
    if (!_isCapturing) return;

    _onHover(position, _data.touchable);
    final onColorSelected = _data.onColorSelected;
    final selectedColor = _data.hoverColors.center;

    _resetCapture();

    if (onColorSelected != null) {
      onColorSelected(selectedColor);
    }
  }

  void _onHover(Offset offset, bool touchable) {
    _data.cursorPosition = offset;
    _data.touchable = touchable;

    if (!_isCapturing) return;

    if (_data.snapshot != null) {
      _data.hoverColor = getPixelColor(_data.snapshot!, offset);
      _data.hoverColors = getPixelColors(_data.snapshot!, offset);
    }

    _data.eyeOverlayEntry?.markNeedsBuild();

    if (_data.onColorChanged != null) {
      _data.onColorChanged!(_data.hoverColors.center);
    }
  }

  void _resetCapture() {
    if (_data.eyeOverlayEntry != null) {
      try {
        if (_data.eyeOverlayEntry!.mounted) {
          _data.eyeOverlayEntry!.remove();
        }
        _data.eyeOverlayEntry!.dispose();
      } catch (err) {
        debugPrint('ERROR !!! _resetCapture $err');
      }
      _data.eyeOverlayEntry = null;
    }
    _data.snapshot = null;
    _data.hoverColors = [];
    _data.onColorSelected = null;
    _data.onColorChanged = null;
  }

  void capture(
    BuildContext context,
    ValueChanged<Color> onColorSelected,
    ValueChanged<Color>? onColorChanged,
  ) async {
    final renderer =
        _captureKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (renderer == null) return;

    _resetCapture();

    _data.onColorSelected = onColorSelected;
    _data.onColorChanged = onColorChanged;

    final snapshot = await repaintBoundaryToImage(renderer);
    if (!mounted || !context.mounted || snapshot == null) return;

    _data.snapshot = snapshot;

    if (_data.cursorPosition != null) {
      _data.hoverColor = getPixelColor(snapshot, _data.cursorPosition!);
      _data.hoverColors = getPixelColors(snapshot, _data.cursorPosition!);
    }

    _data.eyeOverlayEntry = OverlayEntry(
      builder: (_) => EyeDropOverlay(
        touchable: _data.touchable,
        colors: _data.hoverColors,
        cursorPosition: _data.cursorPosition,
      ),
    );

    Overlay.of(context).insert(_data.eyeOverlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return _EyeDropScope(
      state: this,
      child: RepaintBoundary(
        key: _captureKey,
        child: Listener(
          onPointerDown: (details) {
            _data.cursorPosition = details.position;
            _data.touchable = details.kind == PointerDeviceKind.touch;
          },
          onPointerMove: (details) => _onHover(
            details.position,
            details.kind == PointerDeviceKind.touch,
          ),
          onPointerHover: (details) => _onHover(
            details.position,
            details.kind == PointerDeviceKind.touch,
          ),
          onPointerUp: (details) => _onPointerUp(details.position),
          child: widget.child,
        ),
      ),
    );
  }
}

class _EyeDropScope extends InheritedWidget {
  final EyeDropState state;

  const _EyeDropScope({
    required this.state,
    required super.child,
  });

  @override
  bool updateShouldNotify(_EyeDropScope oldWidget) => state != oldWidget.state;
}
