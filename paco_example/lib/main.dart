import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' as rd;
import 'package:flutter/src/gestures/events.dart';
import 'package:paco/paco.dart';
import 'package:image/image.dart' as img;

final captureKey = GlobalKey();

void main() async {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Color color = Colors.black;
  Color hoverColor = Colors.black;
  List<Color> hoverColors = [];

  Uint8List pngBytes;

  ByteData byteData;

  img.Image imag;

  bool captureOn = false;

  OverlayEntry eyeDropperEntry;

  Widget eyeDrop;

  Offset cursorPosition;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: captureKey,
      child: MouseRegion(
        onHover: (details) {
          //print(details.localPosition);
          cursorPosition = details.position;
          if (eyeDropperEntry != null) eyeDropperEntry.markNeedsBuild();
          if (byteData != null) {
            hoverColor = _getPixelColor(cursorPosition);
            hoverColors = _getPixelColors(cursorPosition);

            setState(() {});
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: GestureDetector(
            /*onTap: captureOn ? _captureColor : null,*/

            child: Container(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Row(
                  children: [
                    ColorPicker(
                      /*darkMode: true,*/
                      config: ColorPickerConfig(),
                      selectedColor: color,
                      onColorSelected: (Color value) =>
                          setState(() => color = value),
                      onEyePick: _capture,
                    ),
                    Expanded(
                      child: Container(
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              onPressed: _capture,
                              child: Text('Capture'),
                            ),
                            Text(color.value.toRadixString(16)),
                            Container(color: color, width: 120, height: 120),
                          ],
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getPixelColor(Offset offset) {
    final pixel = imag.getPixel(offset.dx.toInt(), offset.dy.toInt());

    int a = (pixel >> 24) & 0xFF;
    int b = (pixel >> 16) & 0xFF;
    int g = (pixel >> 8) & 0xFF;
    int r = (pixel >> 0) & 0xFF;

    return Color.fromARGB(a, r, g, b);
  }

  List<Color> _getPixelColors(Offset offset) {
    return List.generate(
        25, (index) => _getPixelColor(offset + _offsetFromIndex(index, 5)));
    return List.filled(25, _getPixelColor(offset));
  }

  void _captureColor(Color newColor) {
    print('_MainScreenState._captureColor... ');
    setState(() {
      color = newColor ?? hoverColor;
      captureOn = false;
      eyeDropperEntry.remove();
    });
  }

  void _capture() async {
    captureOn = true;
    rd.RenderRepaintBoundary boundary =
        captureKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 1);
    byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    pngBytes = byteData.buffer.asUint8List();
    imag = img.Image.fromBytes(image.width, image.height, pngBytes);

    eyeDropperEntry = OverlayEntry(
        builder: (_) => EyeDropOverlay(
              color: hoverColor,
              colors: hoverColors,
              cursorPosition: cursorPosition,
              onTap: (value) => _captureColor(value),
            ),
        maintainState: true);
    Overlay.of(context).insert(eyeDropperEntry);

    setState(() {});
  }

  ui.Offset _offsetFromIndex(int index, int numColumns) {
    print(
        'index % numColumns $index ${index % numColumns} ${index ~/ numColumns % numColumns}');
    return Offset((index % numColumns).toDouble(),
        ((index ~/ numColumns) % numColumns).toDouble());
  }
}

class EyeDropOverlay extends StatelessWidget {
  final Offset cursorPosition;

  final Color color;
  final List<Color> colors;

  final ValueChanged<Color> onTap;

  const EyeDropOverlay(
      {Key key, this.cursorPosition, this.color, this.onTap, this.colors})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return cursorPosition != null
        ? Positioned(
            left: cursorPosition.dx - 40,
            top: cursorPosition.dy - 40,
            child: GestureDetector(
              onTap: () => onTap(colors[12]),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    border: Border.all(width: 12, color: Colors.black)),
                foregroundDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 8, color: colors[12])),
                child: _buildPixelGrid(),
                width: 80,
                height: 80,
                constraints: BoxConstraints.loose(Size(100, 100)),
              ),
            ),
          )
        : SizedBox();
  }

  ClipOval _buildPixelGrid() {
    return ClipOval(
      child: GridView.count(
        crossAxisCount: 5,
        children: colors
            .map((c) => Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: c,
                    border: Border.all(width: 1, color: Colors.white),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
