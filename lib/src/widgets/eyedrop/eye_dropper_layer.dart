import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;

import '../../utils.dart';
import 'eye_dropper_overlay.dart';

final captureKey = GlobalKey();

class _EyeDropperModel {
  bool touchable;

  OverlayEntry eyeDropperEntry;

  img.Image image;

  Offset cursorPosition = screenSize.center(Offset.zero);

  Color hoverColor = Colors.black;

  List<Color> hoverColors = [];

  Color selectedColor = Colors.black;

  ValueChanged<Color> onColorSelected;

  _EyeDropperModel();
}

class EyeDrop extends InheritedWidget {
  static _EyeDropperModel data = _EyeDropperModel();

  EyeDrop({Widget child, bool touchable})
      : super(
          child: RepaintBoundary(
            key: captureKey,
            child: Listener(
              onPointerMove: (details) => _onHover(
                  details.position, details.kind == PointerDeviceKind.touch),
              // ignore: deprecated_member_use
              onPointerHover: (details) => _onHover(
                  details.position, details.kind == PointerDeviceKind.touch),
              onPointerUp: (details) => _onPointerUp(details.position),
              child: child,
            ),
          ),
        );

  static EyeDrop of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EyeDrop>();
  }

  static void _onPointerUp(Offset position) {
    _onHover(position, data.touchable);
    if (data.onColorSelected != null)
      data.onColorSelected(data.hoverColors[12]);
    if (data.eyeDropperEntry != null) {
      try {
        data.eyeDropperEntry.remove();
        data.eyeDropperEntry = null;
        data.onColorSelected = null;
      } catch (err) {
        debugPrint('ERROR !!! _onPointerUp $err');
      }
    }
    ;
  }

  static void _onHover(Offset offset, bool touchable) {
    if (data.eyeDropperEntry != null) data.eyeDropperEntry.markNeedsBuild();

    data.cursorPosition = offset;

    data.touchable ??= touchable;

    if (data.image != null) {
      data.hoverColor = getPixelColor(data.image, offset);
      data.hoverColors = getPixelColors(data.image, offset);
    }
  }

  void capture(
      BuildContext context, ValueChanged<Color> onColorSelected) async {
    final renderer =
        captureKey.currentContext.findRenderObject() as RenderRepaintBoundary;

    data.onColorSelected = onColorSelected;

    data.image = await repaintBoundaryToImage(renderer);

    data.eyeDropperEntry = OverlayEntry(
      builder: (_) {
        return EyeDropOverlay(
          touchable: data.touchable,
          color: data.hoverColor,
          colors: data.hoverColors,
          cursorPosition: data.cursorPosition,
          /*onTap: (value) {
            onColorSelected(value);
            data.eyeDropperEntry.remove();
          },*/
        );
      },
    );
    Overlay.of(context).insert(data.eyeDropperEntry);
  }

  @override
  bool updateShouldNotify(EyeDrop oldWidget) {
    return true;
  }
}
