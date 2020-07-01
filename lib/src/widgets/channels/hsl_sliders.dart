import 'dart:math';

import 'package:flutter/material.dart';

import 'channel_slider.dart';
import '../../utils.dart';
import '../../theme.dart';

class HSLSliders extends StatefulWidget {
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const HSLSliders({Key key, this.color, this.onColorChanged})
      : super(key: key);

  @override
  _HSLSlidersState createState() => _HSLSlidersState();
}

class _HSLSlidersState extends State<HSLSliders> {
  HSLColor hsl;
  Color get hslColor =>
      HSLColor.fromAHSL(alpha, hue, saturation, lightness).toColor();

  double alpha;
  double hue;
  double saturation;
  double lightness;

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
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChannelSlider(
          label: Labels.hue,
          selectedColor: hslColor,
          colors: getHueGradientColors(/*saturation: saturation*/),
          channelValueGetter: (color) => max(1, hue) / 360,
          labelGetter: (color) => '${hue.toInt()}',
          onChange: (value) {
            hue = value * 359;
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
          labelGetter: (color) => '${saturation.toStringAsFixed(3)}',
          onChange: (value) {
            saturation = max(0.001, value);
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
            hsl.withSaturation(saturation).withHue(hue).toColor(),
            hsl
                .withSaturation(saturation)
                .withLightness(1)
                .withHue(hue)
                .toColor(),
          ],
          channelValueGetter: (color) => lightness,
          labelGetter: (color) => '${lightness.toStringAsFixed(3)}',
          onChange: (value) {
            lightness = value;
            _updateColor();
          },
        ),
      ],
    );
  }

  void _updateColor() {
    widget.onColorChanged(
      HSLColor.fromAHSL(alpha, hue, saturation, lightness).toColor(),
    );
    setState(() {});
  }
}
