import 'package:flutter/material.dart';

import '../../../theme.dart';
import 'channel_slider.dart';
import 'hsl_sliders.dart';

typedef ChannelValueGetter = double Function(Color value);

typedef ValueLabelGetter = String Function(Color value);

class ChannelSliders extends StatefulWidget {
  final Color selectedColor;

  final ValueChanged<Color> onChange;

  const ChannelSliders(
      {Key key, @required this.selectedColor, @required this.onChange})
      : super(key: key);

  @override
  _ChannelSlidersState createState() => _ChannelSlidersState();
}

class _ChannelSlidersState extends State<ChannelSliders> {
  bool HSLMode = true;

  Color get color => widget.selectedColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final body = textTheme.bodyText1;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Radio<bool>(
              visualDensity: VisualDensity.compact,
              value: true,
              groupValue: HSLMode,
              onChanged: (bool value) => setState(() => HSLMode = value),
            ),
            GestureDetector(
              child: Text('HSL', style: body),
              onTap: () => setState(() => HSLMode = true),
            ),
            SizedBox(width: 70),
            Radio<bool>(
              visualDensity: VisualDensity.compact,
              value: false,
              groupValue: HSLMode,
              onChanged: (bool value) => setState(() => HSLMode = value),
            ),
            GestureDetector(
              child: Text('RGB', style: body),
              onTap: () => setState(() => HSLMode = false),
            ),
          ],
        ),
        HSLMode
            ? HSLSliders(color: color, onColorChanged: widget.onChange)
            : _buildRGBSliders(),
      ],
    );
  }

  Column _buildRGBSliders() {
    return Column(
      children: [
        ChannelSlider(
          label: Labels.red,
          selectedColor: color,
          colors: [color.withRed(0), color.withRed(255)],
          channelValueGetter: (color) => color.red / 255,
          labelGetter: (color) => '${color.red}',
          onChange: (value) =>
              widget.onChange(color.withRed((value * 255).toInt())),
        ),
        ChannelSlider(
          label: Labels.green,
          selectedColor: color,
          colors: [color.withGreen(0), color.withGreen(255)],
          channelValueGetter: (color) => color.green / 255,
          labelGetter: (color) => '${color.green}',
          onChange: (value) =>
              widget.onChange(color.withGreen((value * 255).toInt())),
        ),
        ChannelSlider(
          label: Labels.blue,
          selectedColor: color,
          colors: [color.withBlue(0), color.withBlue(255)],
          channelValueGetter: (color) => color.blue / 255,
          labelGetter: (color) => '${color.blue}',
          onChange: (value) =>
              widget.onChange(color.withBlue((value * 255).toInt())),
        ),
      ],
    );
  }
}
