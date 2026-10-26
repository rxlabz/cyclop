import 'package:cyclop/cyclop.dart';
import 'package:cyclop/src/widgets/selectors/channels/hsl_sliders.dart';
import 'package:cyclop/src/widgets/selectors/user_swatch_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'ColorButton does not trigger onColorChanged on tap down',
    (WidgetTester tester) async {
      int callbackCount = 0;
      Color? changedColor;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ColorButton(
                color: Colors.blue,
                onColorChanged: (c) {
                  callbackCount++;
                  changedColor = c;
                },
              ),
            ),
          ),
        ),
      );

      // Tap down on the color button to open the picker
      await tester.tap(find.byType(ColorButton));
      await tester.pumpAndSettle();

      // Ensure onColorChanged was not called prematurely
      expect(callbackCount, 0);
      expect(changedColor, isNull);

      // Verify the color picker is shown
      expect(find.byType(ColorPicker), findsOneWidget);

      // Close the picker via the close button
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Closing without selecting a new color still should not invoke onColorChanged
      expect(callbackCount, 0);
      expect(changedColor, isNull);
      expect(find.byType(ColorPicker), findsNothing);
    },
  );

  testWidgets(
    'ColorButton dismisses overlay on outside tap or button toggle',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ColorButton(
                color: Colors.blue,
                onColorChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ColorButton));
      await tester.pumpAndSettle();
      expect(find.byType(ColorPicker), findsOneWidget);

      // Tap outside the picker to dismiss
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.byType(ColorPicker), findsNothing);
    },
  );

  testWidgets(
    'ColorPicker triggers onKeyboard with true on focus and false on unfocus',
    (WidgetTester tester) async {
      final keyboardEvents = <bool>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ColorPicker(
                selectedColor: Colors.blue,
                config: const ColorPickerConfig(),
                onClose: () {},
                onColorSelected: (_) {},
                onKeyboard: (visible) => keyboardEvents.add(visible),
              ),
            ),
          ),
        ),
      );

      // Focus the hex textfield
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(keyboardEvents.isNotEmpty, isTrue);
      expect(keyboardEvents.last, isTrue);

      // Unfocus the hex textfield
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();

      expect(keyboardEvents.last, isFalse);
    },
  );

  testWidgets(
    'HSLSliders syncs external color updates and supports 0 saturation',
    (WidgetTester tester) async {
      Color currentColor = const Color(0xffff0000);

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => MaterialApp(
            home: Scaffold(
              body: HSLSliders(
                color: currentColor,
                onColorChanged: (c) => setState(() => currentColor = c),
              ),
            ),
          ),
        ),
      );

      expect(find.text('1.000'), findsOneWidget);

      // External update to green
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => MaterialApp(
            home: Scaffold(
              body: HSLSliders(
                color: const Color(0xff00ff00),
                onColorChanged: (c) => setState(() => currentColor = c),
              ),
            ),
          ),
        ),
      );

      expect(find.text('120'), findsOneWidget);
    },
  );

  testWidgets(
    'SwatchLibrary can add to default const empty swatches without throwing',
    (WidgetTester tester) async {
      Set<Color>? updatedSwatches;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwatchLibrary(
              currentColor: const Color(0xffff0000),
              onColorSelected: (_) {},
              onSwatchesUpdate: (swatches) => updatedSwatches = swatches,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(updatedSwatches, isNotNull);
      expect(updatedSwatches!.contains(const Color(0xffff0000)), isTrue);
    },
  );

  testWidgets(
    'EyeDrop provides state to descendants via EyeDrop.of',
    (WidgetTester tester) async {
      EyeDropState? foundState;

      await tester.pumpWidget(
        MaterialApp(
          home: EyeDrop(
            child: Builder(
              builder: (context) {
                foundState = EyeDrop.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(foundState, isNotNull);
    },
  );
}
