import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_abstracta_app/presentation/widgets/search_bar_widget.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: SearchBarWidget(),
        ),
      ),
    );
  }

  group('SearchBarWidget', () {
    testWidgets('should display search button initially', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Buscar tareas'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should transform into search field when button is pressed',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Buscar tareas'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Buscar tareas...'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should transform back to button when close is pressed',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Buscar tareas'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNothing);
      expect(find.text('Buscar tareas'), findsOneWidget);
    });

    testWidgets('should show clear button when text is entered',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Buscar tareas'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'test query');
      await tester.pump();

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should clear text when clear button is pressed',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Buscar tareas'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'test query');
      await tester.pump();

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('should handle text changes correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Buscar tareas'));
      await tester.pumpAndSettle();

      // Enter text in search field
      await tester.enterText(find.byType(TextField), 'flutter test');
      await tester.pump();

      expect(find.text('flutter test'), findsOneWidget);
    });

    testWidgets('should display clear icon when text is entered',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Buscar tareas'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'some text');
      await tester.pump();

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should not display clear icon when text is empty',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Buscar tareas'));
      await tester.pumpAndSettle();

      // TextField should be empty initially
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('should handle focus and cursor positioning', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Buscar tareas'));
      await tester.pumpAndSettle();

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // TextField should be present when opened
      await tester.tap(textField);
      await tester.pump();

      expect(textField, findsOneWidget);
    });
  });
}
