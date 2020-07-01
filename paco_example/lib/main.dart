import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paco/paco.dart';

void main() async {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: MainScreen(),
        debugShowCheckedModeBanner: false,
      );
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Color appbarColor = Colors.blueGrey;
  Color backgroundColor = Colors.white;
  Set<Color> swatches = Colors.primaries.map((e) => Color(e.value)).toSet();

  @override
  Widget build(BuildContext context) {
    return EyeDrop(
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text('Paco DEMO'),
            backgroundColor: appbarColor,
            actions: [
              Center(
                child: ColorButton(
                  darkMode: true,
                  key: Key('c2'),
                  color: appbarColor,
                  boxShape: BoxShape.rectangle,
                  swatches: swatches,
                  size: 32,
                  config: ColorPickerConfig(
                      enableOpacity: false, enableLibrary: false),
                  onColorChanged: (value) => setState(
                    () => appbarColor = value,
                  ),
                  onSwatchesChanged: (newSwatches) =>
                      setState(() => swatches = newSwatches),
                ),
              )
            ],
          ),
          body: Container(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: ColorButton(
                        darkMode: true,
                        key: Key('c1'),
                        color: backgroundColor,
                        swatches: swatches,
                        onColorChanged: (value) => setState(
                          () => backgroundColor = value,
                        ),
                        onSwatchesChanged: (newSwatches) =>
                            setState(() => swatches = newSwatches),
                      ),
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
