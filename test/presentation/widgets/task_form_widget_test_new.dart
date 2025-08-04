import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';
import 'package:to_do_abstracta_app/presentation/widgets/task_form_widget.dart';

void main() {
  Widget createWidgetUnderTest({Task? task}) {
    return MaterialApp(
      home: Scaffold(
        body: TaskFormWidget(task: task),
      ),
    );
  }

  group('TaskFormWidget', () {
    testWidgets('should display all form fields', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
      expect(find.byType(DropdownButtonFormField), findsAtLeastNWidgets(1));
    });

    testWidgets('should pre-populate fields when editing task',
        (WidgetTester tester) async {
      final testTask = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        status: TaskStatus.pending,
        priority: TaskPriority.medium,
        tags: const ['tag1', 'tag2'],
        assignedUser: 'John Doe',
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(createWidgetUnderTest(task: testTask));
      await tester.pump();

      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('should handle text input correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final titleField = find.byType(TextFormField).first;
      await tester.enterText(titleField, 'New Task Title');
      await tester.pump();

      expect(find.text('New Task Title'), findsOneWidget);
    });
  });
}
