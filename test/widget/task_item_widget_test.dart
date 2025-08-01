import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_abstracta_app/core/di/injection.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';
import 'package:to_do_abstracta_app/presentation/widgets/task_item_widget.dart';

import '../unit/task_usecases_test.mocks.dart';

void main() {
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
  });

  Widget createWidgetUnderTest(Task task) {
    return ProviderScope(
      overrides: [
        taskRepositoryProvider.overrideWithValue(mockRepository),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: TaskItemWidget(task: task, index: 0),
        ),
      ),
    );
  }

  group('TaskItemWidget', () {
    final testTask = Task(
      id: '1',
      title: 'Test Task',
      description: 'Test Description',
      tags: const ['test', 'flutter'],
      status: TaskStatus.pending,
      assignedUser: 'Test User',
      createdAt: DateTime.now(),
      priority: TaskPriority.high,
    );

    testWidgets('should display task information correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testTask));

      expect(find.text('Test Task'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('test'), findsOneWidget);
      expect(find.text('flutter'), findsOneWidget);
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('Pendiente'), findsOneWidget);
    });

    testWidgets('should show checkbox for task completion', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testTask));

      final checkbox = find.byType(Checkbox);
      expect(checkbox, findsOneWidget);

      final checkboxWidget = tester.widget<Checkbox>(checkbox);
      expect(checkboxWidget.value, isFalse);
    });

    testWidgets('should display completed task with strikethrough',
        (tester) async {
      final completedTask = testTask.copyWith(status: TaskStatus.completed);

      await tester.pumpWidget(createWidgetUnderTest(completedTask));

      final titleText = tester.widget<Text>(find.text('Test Task'));
      expect(titleText.style?.decoration, equals(TextDecoration.lineThrough));
    });
  });
}
