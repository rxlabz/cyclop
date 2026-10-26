import 'package:flutter/material.dart';

import '../../theme.dart';

class MainTitle extends StatelessWidget {
  final VoidCallback? onClose;

  const MainTitle({super.key, this.onClose});

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
              style: textTheme.titleSmall,
            ),
          ),
          onClose != null
              ? IconButton(icon: const Icon(Icons.close), onPressed: onClose)
              : const SizedBox(height: 48)
        ],
      ),
    );
  }
}
