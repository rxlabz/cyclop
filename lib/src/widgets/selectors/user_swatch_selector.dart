import 'package:cyclop/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:quiver/collection.dart';

class SwatchLibrary extends StatefulWidget {
  final Set<Color> colors;
  final Color currentColor;
  final ValueChanged<Set<Color>> onSwatchesUpdate;
  final ValueChanged<Color> onColorSelected;

  const SwatchLibrary({
    Key key,
    this.colors,
    this.currentColor,
    this.onSwatchesUpdate,
    this.onColorSelected,
  }) : super(key: key);

  bool get canAdd => !colors.contains(currentColor);

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridView.count(
      crossAxisCount: 8,
      children: [
        ...widget.colors.map(_colorToSwatch),
        Container(
          /*margin: const EdgeInsets.all(4),*/
          /*padding: const EdgeInsets.all(4),*/
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: IconButton(
              color: widget.canAdd
                  ? theme.toggleableActiveColor
                  : theme.disabledColor,
              icon: Icon(Icons.add),
              onPressed: widget.canAdd
                  ? () {
                      setState(() => colors.add(widget.currentColor));
                      final newSwatches = widget.colors
                        ..add(widget.currentColor);
                      widget.onSwatchesUpdate(newSwatches);
                    }
                  : null,
            ),
          ),
        )
      ],
    );
  }

  Widget _colorToSwatch(Color color) => GestureDetector(
        onTap: () => widget.onColorSelected(color),
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(4),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            /*boxShadow: color == widget.currentColor ? defaultShadowBox : [],*/
          ),
          foregroundDecoration: BoxDecoration(
            border: color == widget.currentColor
                ? Border.all(color: Colors.white /*grey.shade600*/, width: 3)
                : null,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
}
