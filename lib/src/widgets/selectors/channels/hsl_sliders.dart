import 'package:flutter/material.dart';

import '../../../theme.dart';
import '../../../utils.dart';
import 'channel_slider.dart';

class HSLSliders extends StatefulWidget {
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const HSLSliders({
    required this.color,
    required this.onColorChanged,
    super.key,
  });

  @override
  HSLSlidersState createState() => HSLSlidersState();
}

class HSLSlidersState extends State<HSLSliders> {
  late HSLColor hsl;

  late double alpha;

  late double hue;

  late double saturation;

  late double lightness;

  Color get hslColor =>
      HSLColor.fromAHSL(alpha, hue, saturation, lightness).toColor();

  @override
  void initState() {
    super.initState();
    hsl = widget.color.hsl;
    alpha = hsl.alpha;
    hue = hsl.hue;
    saturation = hsl.saturation;
    lightness = hsl.lightness;
  }

  @override
  void didUpdateWidget(covariant HSLSliders oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color && widget.color != hslColor) {
      final newHsl = widget.color.hsl;
      alpha = newHsl.alpha;
      saturation = newHsl.saturation;
      lightness = newHsl.lightness;
      if (saturation > 0 && lightness > 0 && lightness < 1) {
        hue = newHsl.hue;
      }
      hsl = HSLColor.fromAHSL(alpha, hue, saturation, lightness);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChannelSlider(
          label: Labels.hue,
          selectedColor: hslColor,
          colors: getHueGradientColors(/*saturation: saturation*/),
          channelValueGetter: (color) => hue / 360,
          labelGetter: (color) => '${hue.toInt()}',
          onChange: (value) {
            hue = value * 360;
            _updateColor();
          },
        ),
        ChannelSlider(
          label: Labels.saturation,
          selectedColor: hslColor,
          colors: [
            hsl
                .withSaturation(0)
                .withLightness(lightness)
                .withHue(hue)
                .toColor(),
            hsl
                .withSaturation(1)
                .withLightness(lightness)
                .withHue(hue)
                .toColor(),
          ],
          channelValueGetter: (color) => saturation,
          labelGetter: (color) => saturation.toStringAsFixed(3),
          onChange: (value) {
            saturation = value;
            _updateColor();
          },
        ),
        ChannelSlider(
          label: Labels.light,
          selectedColor: hslColor,
          colors: [
            hsl
                .withSaturation(saturation)
                .withLightness(0)
                .withHue(hue)
                .toColor(),
            hsl
                .withSaturation(saturation)
                .withLightness(0.5)
                .withHue(hue)
                .toColor(),
            hsl
                .withSaturation(saturation)
                .withLightness(1)
                .withHue(hue)
                .toColor(),
          ],
          channelValueGetter: (color) => lightness,
          labelGetter: (color) => lightness.toStringAsFixed(3),
          onChange: (value) {
            lightness = value;
            _updateColor();
          },
        ),
      ],
    );
  }

  void _updateColor() {
    hsl = HSLColor.fromAHSL(alpha, hue, saturation, lightness);
    widget.onColorChanged(hsl.toColor());
    setState(() {});
  }
}
