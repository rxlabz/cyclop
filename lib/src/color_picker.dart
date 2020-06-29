import 'package:flutter/material.dart';
import 'package:paco/src/selectors/grid_color_selector.dart';
import 'package:paco/src/selectors/hsl_selector.dart';
import 'package:paco/src/selectors/user_swatch_selector.dart';
import 'package:paco/src/tabbar.dart';
import 'package:paco/src/widgets/opacity/opacity_slider.dart';
import 'package:paco/src/theme.dart';

import 'widgets/color_selector.dart';
import 'widgets/title_bar.dart';

const pickerWidth = 316.0;

const pickerHeight = 520.0;

class ColorPickerConfig {
  final bool enableOpacity;

  final bool enableFavorites;

  final bool enableEyePicker;

  ColorPickerConfig({
    this.enableOpacity = true,
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

  final VoidCallback onEyeDropper;

  final ValueChanged<List<Color>> onFavoritesUpdate;

  final VoidCallback onClose;

  const ColorPicker({
    Key key,
    @required this.onColorSelected,
    @required this.selectedColor,
    @required this.config,
    this.favorites = const [],
    this.darkMode = false,
    this.onFavoritesUpdate,
    this.onEyeDropper,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: darkMode ? darkTheme : lightTheme,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Container(
            constraints: BoxConstraints.tight(Size(pickerWidth, pickerHeight)),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(defaultRadius),
              boxShadow: largeDarkShadowBox,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MainTitle(onClose: onClose),
                Expanded(
                  child: Tabs(
                    onIndexChanged: (int value) {},
                    labels: ['Material', 'Sliders', 'Library'],
                    views: [
                      GridColorSelector(
                        selectedColor: selectedColor,
                        onColorSelected: onColorSelected,
                      ),
                      ChannelSliders(
                        selectedColor: selectedColor,
                        onChange: onColorSelected,
                      ),
                      SwatchLibrary(),
                    ],
                  ),
                ),
                if (config.enableOpacity)
                  RepaintBoundary(
                    child: OpacitySlider(
                      selectedColor: selectedColor,
                      opacity: selectedColor.opacity,
                      onChange: _onOpacityChange,
                    ),
                  ),
                defaultDivider,
                ColorSelector(
                  color: selectedColor,
                  withAlpha: config.enableOpacity,
                  thumbWidth: 96,
                  onColorChanged: onColorSelected,
                  onEyePick: onEyeDropper,
                ),
                /*defaultDivider,*/
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
