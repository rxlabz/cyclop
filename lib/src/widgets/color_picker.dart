import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/opacity/opacity_slider.dart';
import '../widgets/tabbar.dart';
import 'picker/color_selector.dart';
import 'picker/title_bar.dart';
import 'picker_config.dart' if (dart.library.js) 'picker_config_web.dart';
import 'selectors/channels/hsl_selector.dart';
import 'selectors/grid_color_selector.dart';
import 'selectors/user_swatch_selector.dart';

const pickerWidth = 316.0;

const pickerHeight = 520.0;

const pickerSize = Size(pickerWidth, pickerHeight);

/// ColorPicker Widget
/// 2 or 3 tabs :
/// - material swatches
/// - HSL and RGB sliders
/// - custom swatches
///
/// Customisable with a [ColorPickerConfig]
class ColorPicker extends StatefulWidget {
  final Color selectedColor;

  /// custom swatches library
  final Set<Color> swatches;

  final bool darkMode;

  /// colorPicker configuration
  final ColorPickerConfig config;

  /// color selection callback
  final ValueChanged<Color> onColorSelected;

  /// open [EyeDrop] callback
  final VoidCallback onEyeDropper;

  /// custom swatches update callabck
  final ValueChanged<Set<Color>>? onSwatchesUpdate;

  /// close colorPicker callback
  final VoidCallback onClose;

  final VoidCallback onKeyboard;

  const ColorPicker({
    required this.onColorSelected,
    required this.selectedColor,
    required this.config,
    required this.onClose,
    required this.onEyeDropper,
    required this.onKeyboard,
    this.onSwatchesUpdate,
    this.swatches = const {},
    this.darkMode = false,
    Key? key,
  }) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late FocusNode hexFieldFocus;

  @override
  void initState() {
    super.initState();
    hexFieldFocus = FocusNode()..addListener(widget.onKeyboard);
  }

  @override
  void dispose() {
    super.dispose();
    hexFieldFocus.removeListener(widget.onKeyboard);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.darkMode ? darkTheme : lightTheme,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Container(
            constraints: BoxConstraints.loose(pickerSize),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(defaultRadius),
              boxShadow: largeDarkShadowBox,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MainTitle(onClose: widget.onClose),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Tabs(
                      labels: [
                        'Material',
                        'Sliders',
                        if (widget.config.enableLibrary) 'Library'
                      ],
                      views: [
                        GridColorSelector(
                          selectedColor: widget.selectedColor,
                          onColorSelected: widget.onColorSelected,
                        ),
                        ChannelSliders(
                          selectedColor: widget.selectedColor,
                          onChange: widget.onColorSelected,
                        ),
                        if (widget.config.enableLibrary)
                          SwatchLibrary(
                            colors: widget.swatches,
                            currentColor: widget.selectedColor,
                            onSwatchesUpdate: widget.onSwatchesUpdate,
                            onColorSelected: widget.onColorSelected,
                          ),
                      ],
                    ),
                  ),
                  if (widget.config.enableOpacity)
                    RepaintBoundary(
                      child: OpacitySlider(
                        selectedColor: widget.selectedColor,
                        opacity: widget.selectedColor.opacity,
                        onChange: _onOpacityChange,
                      ),
                    ),
                  defaultDivider,
                  ColorSelector(
                    color: widget.selectedColor,
                    withAlpha: widget.config.enableOpacity,
                    thumbWidth: 96,
                    onColorChanged: widget.onColorSelected,
                    onEyePick: widget.config.enableEyePicker
                        ? widget.onEyeDropper
                        : null,
                    focus: hexFieldFocus,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onOpacityChange(double value) =>
      widget.onColorSelected(widget.selectedColor.withOpacity(value));
}
