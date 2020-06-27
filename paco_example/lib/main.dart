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
  Color color = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Row(
            children: [
              ColorPicker(
                /*darkMode: true,*/
                config: ColorPickerConfig(),
                selectedColor: color,
                onColorSelected: (Color value) => setState(() => color = value),
              ),
              Expanded(
                child: Container(
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(color.value.toRadixString(16)),
                      Container(color: color, width: 120, height: 120)
                    ],
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
