import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../data.dart';
import 'opacity_slider_thumb.dart';
import 'opacity_slider_track.dart';

class OpacitySlider extends StatelessWidget {
  final double opacity;

  final Color selectedColor;

  final ValueChanged<double> onChange;

  const OpacitySlider({
    Key key,
    @required this.opacity,
    @required this.selectedColor,
    @required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder<ui.Image>(
      future: getGridImage(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox();
        return Padding(
          padding: const EdgeInsets.only(top: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(Labels.opacity, style: textTheme.subtitle2),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Theme(
                      data: opacitySliderTheme(selectedColor),
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
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    padding: EdgeInsets.all(8),
                    color: Colors.white,
                    width: 60,
                    child: Text(
                      '${(opacity * 100).toInt()}%',
                      textAlign: TextAlign.center,
                      style: textTheme.subtitle1,
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

ui.Image _gridImage;

FutureOr<ui.Image> getGridImage() {
  if (_gridImage != null) return Future.value(_gridImage);
  Completer<ui.Image> completer = new Completer<ui.Image>();
  AssetImage('packages/paco/assets/grid.png')
      .resolve(new ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
    _gridImage = info.image;
    completer.complete(_gridImage);
  }));
  return completer.future;
}

ThemeData opacitySliderTheme(Color color) => ThemeData.light().copyWith(
      sliderTheme: SliderThemeData(
          trackHeight: 24,
          thumbColor: Colors.white,
          trackShape: OpacitySliderTrack(color, gridImage: _gridImage),
          thumbShape: OpacitySliderThumbShape(color)),
    );
