import 'package:flutter/material.dart';
import 'package:quiver/collection.dart';

class SwatchLibrary extends StatefulWidget {
  final Set<Color> colors;
  final Color currentColor;

  const SwatchLibrary({Key key, this.colors, this.currentColor})
      : super(key: key);

  @override
  _SwatchLibraryState createState() => _SwatchLibraryState();
}

class _SwatchLibraryState extends State<SwatchLibrary> {
  Set<Color> colors;

  @override
  void initState() {
    super.initState();
    colors = widget.colors;
  }

  @override
  void didUpdateWidget(SwatchLibrary oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!setsEqual(oldWidget.colors, widget.colors)) {
      colors = widget.colors;
    }
  }

  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: 8,
        children: [
          ...colors.map(_colorToSwatch),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => setState(() => colors.add(widget.currentColor)),
          )
        ],
      );

  Widget _colorToSwatch(Color color) =>
      Container(width: 30, height: 30, color: color);
}
