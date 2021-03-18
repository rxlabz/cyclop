import 'package:flutter/material.dart';

import '../../theme.dart';

class MainTitle extends StatelessWidget {
  final VoidCallback? onClose;

  const MainTitle({Key? key, this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              Labels.mainTitle,
              style: textTheme.subtitle2,
            ),
          ),
          onClose != null
              ? IconButton(icon: Icon(Icons.close), onPressed: onClose)
              : SizedBox(height: 48)
        ],
      ),
    );

/* TODO(rx) : make it draggable
 GestureDetector(
      onPanStart: (details) => print('PAN'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                Labels.mainTitle,
                style: textTheme.subtitle2,
              ),
            ),
            onClose != null
                ? IconButton(icon: Icon(Icons.close), onPressed: onClose)
                : SizedBox(height: 48)
          ],
        ),
      ),
    );*/
  }
}
