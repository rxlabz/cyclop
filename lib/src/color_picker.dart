import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:paco/data.dart';
import 'package:paco/src/selectors/grid_color_selector.dart';
import 'package:paco/src/tabbar.dart';
import 'package:paco/src/widgets/opacity/opacity_slider.dart';

class ColorPickerConfig {
  final bool enableOpacity;

  final bool enableFavorites;

  final bool enableEyePicker;

  ColorPickerConfig({
    this.enableOpacity = false,
    this.enableFavorites = false,
    this.enableEyePicker = true,
  });
}

class ColorPicker extends StatelessWidget {
  final Color selectedColor;

  final List<Color> favorites;

  final bool darkMode;

  final ColorPickerConfig config;

  final ValueChanged<Color> onColorSelected;

  final ValueChanged<List<Color>> onFavoritesUpdate;

  const ColorPicker({
    Key key,
    @required this.onColorSelected,
    @required this.selectedColor,
    @required this.config,
    this.favorites = const [],
    this.darkMode = false,
    this.onFavoritesUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: darkMode ? darkTheme : lightTheme,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Container(
            constraints: BoxConstraints.tight(Size(300, 510)),
            color: theme.dialogTheme.backgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MainTitle(onEyePicker: () {}),
                Tabs(onIndexChanged: (int value) {}),
                GridColorSelector(
                  selectedColor: selectedColor,
                  onColorSelected: onColorSelected,
                ),
                /*Image.asset('packages/paco/assets/grid.png'),*/
                OpacitySlider(
                  selectedColor: selectedColor,
                  opacity: selectedColor.opacity,
                  onChange: _onOpacityChange,
                ),
                Text('preview'),
                Text('actionBar'),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onOpacityChange(double value) =>
      onColorSelected(selectedColor.withOpacity(value));
}

class MainTitle extends StatelessWidget {
  final VoidCallback onEyePicker;

  const MainTitle({Key key, this.onEyePicker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              Labels.mainTitle,
              style: textTheme.subtitle2,
            ),
          ),
          if (onEyePicker != null)
            IconButton(
              icon: Icon(Icons.colorize),
              onPressed: onEyePicker,
            )
        ],
      ),
    );
  }
}
