import 'package:cyclop/src/widgets/picker/hex_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'HexTextField white',
    (WidgetTester tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);

      final app = MaterialApp(
        home: Scaffold(
          body: Center(
            child: HexColorField(
              color: Colors.white,
              withAlpha: true,
              hexFocus: focus,
              onColorChanged: (Color value) {},
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);

      expect(find.text('ffffffff'), findsOneWidget);
    },
  );

  testWidgets(
    'HexTextField black',
    (WidgetTester tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);

      final app = MaterialApp(
        home: Scaffold(
          body: Center(
            child: HexColorField(
              color: Colors.black,
              withAlpha: true,
              hexFocus: focus,
              onColorChanged: (Color value) {},
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);

      expect(find.text('ff000000'), findsOneWidget);
    },
  );

  testWidgets(
    'HexTextField black alpha0',
    (WidgetTester tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);

      final app = MaterialApp(
        home: Scaffold(
          body: Center(
            child: HexColorField(
              color: Colors.black.withValues(alpha: 0),
              withAlpha: true,
              hexFocus: focus,
              onColorChanged: (Color value) {},
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);

      expect(find.text('00000000'), findsOneWidget);
    },
  );

  testWidgets(
    'HexTextField white alpha0',
    (WidgetTester tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);

      final app = MaterialApp(
        home: Scaffold(
          body: Center(
            child: HexColorField(
              color: Colors.white.withValues(alpha: 0),
              withAlpha: true,
              hexFocus: focus,
              onColorChanged: (Color value) {},
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);

      expect(find.text('00ffffff'), findsOneWidget);
    },
  );

  testWidgets(
    'HexTextField updates color on submit and focus loss',
    (WidgetTester tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      Color? updatedColor;

      final app = MaterialApp(
        home: Scaffold(
          body: Center(
            child: HexColorField(
              color: Colors.white,
              withAlpha: false,
              hexFocus: focus,
              onColorChanged: (Color value) => updatedColor = value,
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);

      await tester.enterText(find.byType(TextField), 'ff0000');
      focus.unfocus();
      await tester.pump();

      expect(updatedColor, const Color(0xffff0000));
    },
  );
}
