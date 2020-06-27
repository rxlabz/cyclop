import 'package:flutter/material.dart';

class GridColorSelector extends StatelessWidget {
  final Color selectedColor;

  final ValueChanged<Color> onColorSelected;

  const GridColorSelector({Key key, this.selectedColor, this.onColorSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height: 210),
      margin: EdgeInsets.symmetric(horizontal: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: GridView.count(
          crossAxisCount: 12,
          children: _buildColorsTiles(),
          childAspectRatio: 1,
        ),
      ),
    );
  }

  List<Widget> _buildColorsTiles() => _buildColorGridValues()
      .map(
        (color) => GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(selectedColor.value == color.value ? 3 : 0),
            child: Container(color: color, width: 20, height: 20),
          ),
        ),
      )
      .toList();

  List<Color> _buildColorGridValues({int rows = 9, int columns = 12}) => [
        ...Colors.white.getShades(columns, skipFirst: false),
        for (final primary in Colors.primaries) ...primary.getShades(columns)
      ];
}

extension on Color {
  HSLColor get hsl => HSLColor.fromColor(this);

  List<Color> getShades(int stepCount, {bool skipFirst = true}) {
    return List.generate(stepCount, (index) {
      return hsl
          .withLightness(1 -
              ((index + (skipFirst ? 1 : 0)) /
                  (stepCount - (skipFirst ? -1 : 1))))
          .toColor();
    });
  }
}
