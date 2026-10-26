import 'package:flutter/material.dart';

import '../../theme.dart';
import 'opacity_slider_thumb.dart';
import 'opacity_slider_track.dart';

class OpacitySlider extends StatelessWidget {
  final double opacity;

  final Color selectedColor;

  final ValueChanged<double> onChange;

  const OpacitySlider({
    required this.opacity,
    required this.selectedColor,
    required this.onChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(Labels.opacity, style: textTheme.titleLarge),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SliderTheme(
                  data: _opacitySliderTheme(selectedColor),
                  child: Slider(
                    value: opacity,
                    min: 0,
                    max: 1,
                    divisions: 100,
                    onChanged: onChange,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.inputDecorationTheme.fillColor,
                  borderRadius: defaultBorderRadius,
                ),
                width: 60,
                child: Text(
                  '${(opacity * 100).toInt()}%',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium,
                  maxLines: 1,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

SliderThemeData _opacitySliderTheme(Color color) => SliderThemeData(
      trackHeight: 24,
      thumbColor: Colors.white,
      trackShape: OpacitySliderTrack(color),
      thumbShape: OpacitySliderThumbShape(color),
    );
