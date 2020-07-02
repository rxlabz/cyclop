import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cyclop/cyclop.dart';

void main() async {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: EyeDrop(child: MainScreen()),
        debugShowCheckedModeBanner: false,
      );
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Color appbarColor = Colors.blueGrey;
  Color backgroundColor = Colors.grey.shade200;
  Set<Color> swatches = Colors.primaries.map((e) => Color(e.value)).toSet();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Cyclop Demo'),
        backgroundColor: appbarColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
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
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Column(
            children: [
              Text(
                'Select the background & appbar colors',
                style: textTheme.headline6,
              ),
              _buildButtons(),
              if (!kIsWeb) Center(child: Image.asset('images/img.png')),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildButtons() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: ColorButton(
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
          Center(
            child: ColorButton(
              key: Key('c1'),
              size: 32,
              color: backgroundColor,
              swatches: swatches,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: backgroundColor,
                border: Border.all(width: 4, color: Colors.black),
              ),
              onColorChanged: (value) => setState(
                () => backgroundColor = value,
              ),
              onSwatchesChanged: (newSwatches) =>
                  setState(() => swatches = newSwatches),
            ),
          ),
          if (!kIsWeb)
            EyedropperButton(
              icon: Icons.colorize,
              onColor: (value) => setState(() => backgroundColor = value),
            ),
        ],
      ),
    );
  }
}
