import 'package:flutter/material.dart';

import 'eye_dropper_layer.dart';

/// an eyeDropper standalone button
class EyedropperButton extends StatelessWidget {
  /// customisable icon ( default : [Icons.colorize] )
  final IconData icon;

  /// icon color, default : [Colors.blueGrey]
  final Color iconColor;

  /// color selection callback
  final ValueChanged<Color> onColor;

  const EyedropperButton({
    required this.onColor,
    this.icon = Icons.colorize,
    this.iconColor = Colors.black54,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration:
            BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
        child: IconButton(
          icon: Icon(Icons.colorize),
          color: iconColor,
          onPressed: () => _onEyeDropperRequest(context),
        ),
      );

  void _onEyeDropperRequest(BuildContext context) {
    try {
      EyeDrop.of(context).capture(context, onColor);
    } catch (err) {
      throw Exception('EyeDrop capture error : $err');
    }
  }
}
