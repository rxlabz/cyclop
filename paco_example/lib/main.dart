import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paco/paco.dart';

void main() async {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(home: MainScreen());
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Color color1 = Colors.black;
  Color color2 = Colors.cyan;
  Color color3 = Colors.yellow;
  Color color4 = Colors.pink;
  Color backgroundColor = Colors.white;
  Set<Color> swatches = Colors.primaries.map((e) => Color(e.value)).toSet();

  @override
  Widget build(BuildContext context) {
    return EyeDrop(
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: backgroundColor,
          body: Container(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ColorButton(
                          darkMode: true,
                          key: Key('c1'),
                          color: color1,
                          swatches: swatches,
                          onColorChanged: (value) => setState(
                            () => color1 = value,
                          ),
                          onSwatchesChanged: (newSwatches) =>
                              setState(() => swatches = newSwatches),
                        ),
                        ColorButton(
                          darkMode: true,
                          key: Key('c2'),
                          color: color2,
                          boxShape: BoxShape.rectangle,
                          swatches: swatches,
                          config: ColorPickerConfig(
                              enableOpacity: false, enableLibrary: false),
                          onColorChanged: (value) => setState(
                            () => color2 = value,
                          ),
                          onSwatchesChanged: (newSwatches) =>
                              setState(() => swatches = newSwatches),
                        ),
                        ColorButton(
                          darkMode: true,
                          key: Key('c3'),
                          color: color3,
                          swatches: swatches,
                          onColorChanged: (value) => setState(
                            () => color3 = value,
                          ),
                          onSwatchesChanged: (newSwatches) =>
                              setState(() => swatches = newSwatches),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: ColorButton(
                            key: Key('c4'),
                            color: color4,
                            config: ColorPickerConfig(enableEyePicker: false),
                            size: 32,
                            swatches: swatches,
                            onColorChanged: (value) => setState(
                              () => color4 = value,
                            ),
                            onSwatchesChanged: (newSwatches) =>
                                setState(() => swatches = newSwatches),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!kIsWeb) Center(child: Image.asset('images/img.png')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
