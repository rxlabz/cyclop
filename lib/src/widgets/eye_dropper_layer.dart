import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;

import '../utils.dart';
import 'eye_dropper.dart';

final captureKey = GlobalKey();

class _EyeDropperModel {
  OverlayEntry eyeDropperEntry;

  img.Image image;

  Offset cursorPosition;

  Color hoverColor = Colors.black;

  List<Color> hoverColors = [];

  Color selectedColor = Colors.black;

  _EyeDropperModel();
}

class EyeDropperLayer extends InheritedWidget {
  static _EyeDropperModel data = _EyeDropperModel();

  EyeDropperLayer({Widget child})
      : super(
          child: RepaintBoundary(
            key: captureKey,
            child: MouseRegion(onHover: _onHover, child: child),
          ),
        );

  static EyeDropperLayer of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EyeDropperLayer>();
  }

  static void _onHover(PointerHoverEvent details) {
    if (data.eyeDropperEntry != null) data.eyeDropperEntry.markNeedsBuild();

    data.cursorPosition = details.position;

    if (data.image != null) {
      data.hoverColor = getPixelColor(data.image, details.position);
      data.hoverColors = getPixelColors(data.image, details.position);
    }
  }

  void capture(
      BuildContext context, ValueChanged<Color> onColorSelected) async {
    final renderer =
        captureKey.currentContext.findRenderObject() as RenderRepaintBoundary;

    data.image = await repaintBoundaryToImage(renderer);

    data.eyeDropperEntry = OverlayEntry(
        builder: (_) {
          return EyeDropOverlay(
            color: data.hoverColor,
            colors: data.hoverColors,
            cursorPosition: data.cursorPosition,
            onTap: (value) {
              onColorSelected(value);
              data.eyeDropperEntry.remove();
            },
          );
        },
        maintainState: true);
    Overlay.of(context).insert(data.eyeDropperEntry);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
