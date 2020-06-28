import 'package:flutter/material.dart';

import '../theme.dart';
import '../utils.dart';

const _cellSize = 25.0;
const _numColumns = 12;

const _cellBorderWidth = 3.0;

class GridColorSelector extends StatelessWidget {
  final Color selectedColor;

  final ValueChanged<Color> onColorSelected;

  final VoidCallback onEyePick;

  const GridColorSelector(
      {Key key, this.selectedColor, this.onColorSelected, this.onEyePick})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        constraints: BoxConstraints.expand(),
        margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(defaultRadius)),
          child: GridView.count(
            crossAxisCount: 12,
            children: _buildColorsTiles(),
            childAspectRatio: 1,
          ),
        ),
      );

  List<Widget> _buildColorsTiles() =>
      _buildColorGridValues().map(_buildCell).toList();

  List<Color> _buildColorGridValues({int columns = _numColumns}) => [
        ...Colors.white.getShades(columns, skipFirst: false),
        for (final primary in Colors.primaries) ...primary.getShades(columns)
      ];

  GestureDetector _buildCell(Color color) => GestureDetector(
        onTap: () => onColorSelected(color),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(isSelected(color) ? _cellBorderWidth : 0),
          child: Container(color: color, width: _cellSize, height: _cellSize),
        ),
      );

  bool isSelected(Color color) =>
      selectedColor.withOpacity(1).value == color.withOpacity(1).value;
}
