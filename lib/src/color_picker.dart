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

  final bool enableLibrary;

  final bool enableEyePicker;

  const ColorPickerConfig({
    this.enableOpacity = true,
    this.enableLibrary = true,
    this.enableEyePicker = true,
  });
}

class ColorPicker extends StatelessWidget {
  final Color selectedColor;

  final Set<Color> swatches;

  final bool darkMode;

  final ColorPickerConfig config;

  final ValueChanged<Color> onColorSelected;

  final VoidCallback onEyeDropper;

  final ValueChanged<Set<Color>> onSwatchesUpdate;

  final VoidCallback onClose;

  const ColorPicker({
    Key key,
    @required this.onColorSelected,
    @required this.selectedColor,
    @required this.config,
    this.swatches = const {},
    this.darkMode = false,
    this.onSwatchesUpdate,
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
                    labels: [
                      'Material',
                      'Sliders',
                      if (config.enableLibrary) 'Library'
                    ],
                    views: [
                      GridColorSelector(
                        selectedColor: selectedColor,
                        onColorSelected: onColorSelected,
                      ),
                      ChannelSliders(
                        selectedColor: selectedColor,
                        onChange: onColorSelected,
                      ),
                      if (config.enableLibrary)
                        SwatchLibrary(
                          colors: swatches,
                          currentColor: selectedColor,
                          onSwatchesUpdate: onSwatchesUpdate,
                          onColorSelected: onColorSelected,
                        ),
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
                  onEyePick: config.enableEyePicker ? onEyeDropper : null,
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
