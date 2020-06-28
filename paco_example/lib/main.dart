import 'package:flutter/material.dart';
import 'package:paco/paco.dart';

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
  Color color1 = Colors.black;
  Color color2 = Colors.black;
  Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return EyeDropperLayer(
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: backgroundColor,
          body: GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ColorPicker(
                      darkMode: true,
                      config: ColorPickerConfig(enableOpacity: false),
                      selectedColor: backgroundColor,
                      onColorSelected: (Color value) =>
                          setState(() => backgroundColor = value),
                      onEyeDropper: () => EyeDropperLayer.of(context).capture(
                          context,
                          (value) => setState(() => backgroundColor = value)),
                    ),
                    Expanded(
                      child: Center(
                        child: ColorButton(
                          darkMode: true,
                          key: Key('c1'),
                          color: color1,
                          onColorChanged: (value) => setState(
                            () => color1 = value,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ColorButton(
                        key: Key('c2'),
                        color: color2,
                        onColorChanged: (value) => setState(
                          () => color2 = value,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Center(child: Image.asset('images/girafe.png')),
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
}
