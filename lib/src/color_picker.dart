import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:paco/data.dart';
import 'package:paco/src/selectors/grid_color_selector.dart';
import 'package:paco/src/tabbar.dart';
import 'package:paco/src/widgets/opacity/opacity_slider.dart';

import 'widgets/color_preview.dart';
import 'widgets/color_selector.dart';
import 'widgets/title_bar.dart';

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

  final VoidCallback onEyePick;

  final ValueChanged<List<Color>> onFavoritesUpdate;

  const ColorPicker({
    Key key,
    @required this.onColorSelected,
    @required this.selectedColor,
    @required this.config,
    this.favorites = const [],
    this.darkMode = false,
    this.onFavoritesUpdate,
    this.onEyePick,
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
                MainTitle(onClose: _close),
                Tabs(onIndexChanged: (int value) {}),
                GridColorSelector(
                  selectedColor: selectedColor,
                  onColorSelected: onColorSelected,
                ),
                /*Image.asset('packages/paco/assets/grid.png'),*/
                RepaintBoundary(
                  child: OpacitySlider(
                    selectedColor: selectedColor,
                    opacity: selectedColor.opacity,
                    onChange: _onOpacityChange,
                  ),
                ),
                _defaultDivider,
                ColorSelector(
                  color: selectedColor,
                  withAlpha: true,
                  thumbWidth: 96,
                  onColorChanged: onColorSelected,
                  onEyePick: onEyePick,
                ),
                /*ColorPreview(selectedColor: selectedColor),*/
                _defaultDivider,
                /*_ActionBar(
                  onColorSelected: ()=>onColorSelected ,
                  onCancel: ,
                ),*/
              ],
            ),
          );
        },
      ),
    );
  }

  void _onOpacityChange(double value) =>
      onColorSelected(selectedColor.withOpacity(value));

  void _close() {
    print('ColorPicker._close...');
  }
}
/*

class _ActionBar extends StatelessWidget {
  final VoidCallback onCancel;

  final VoidCallback onColorSelected;

  const _ActionBar({
    Key key,
    @required this.onCancel,
    @required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FlatButton.icon(
          onPressed: onCancel,
          icon: Icon(Icons.close),
          label: Text('Cancel'),
        ),
        FlatButton.icon(
          textTheme: ButtonTextTheme.accent,
          onPressed: onColorSelected,
          icon: Icon(Icons.check),
          label: Text('Save'),
        ),
      ],
    );
  }
}
*/

const _defaultDivider = Divider(
  color: Color(0xff999999),
  indent: 8,
  height: 10,
  endIndent: 8,
);
