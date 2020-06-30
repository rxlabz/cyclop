import 'package:flutter/material.dart';
import 'package:paco/src/theme.dart';
import 'package:quiver/iterables.dart';

class Tabs extends StatefulWidget {
  final int selectedIndex;

  final ValueChanged<int> onIndexChanged;

  final List<String> labels;

  final List<Widget> views;

  const Tabs({
    @required this.labels,
    @required this.views,
    @required this.onIndexChanged,
    this.selectedIndex = 0,
    Key key,
  }) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int selectedIndex = 0;

  Alignment get markerPosition {
    switch (selectedIndex) {
      case 0:
        return Alignment.topLeft;
      case 1:
        return widget.labels.length == 2
            ? Alignment.topRight
            : Alignment.topCenter;
      case 2:
        return Alignment.topRight;
    }
    throw Exception();
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        _buildTabs(theme, size),
        Expanded(child: widget.views[selectedIndex])
      ],
    );
  }

  Container _buildTabs(ThemeData theme, Size size) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 14),
      constraints: BoxConstraints.expand(height: 42),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme.backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              alignment: markerPosition,
              child: Container(
                width: 86,
                height: size.height,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: defaultShadowBox,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: enumerate(widget.labels).map(_buildTab).toList(),
            )
          ],
        ),
      ),
    );
  }

  void _onSelectionChanged(int newIndex) =>
      setState(() => selectedIndex = newIndex);

  Flexible _buildTab(IndexedValue<String> label) => Flexible(
        flex: 1,
        child: FlatButton(
          child: Text(label.value),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onPressed: () => _onSelectionChanged(label.index),
        ),
      );
}
