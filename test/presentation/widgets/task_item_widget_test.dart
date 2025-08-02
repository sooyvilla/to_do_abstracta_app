import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';
import 'package:to_do_abstracta_app/presentation/widgets/task_item_widget.dart';

void main() {
  Widget createWidgetUnderTest(Task task) {
    return MaterialApp(
      home: Scaffold(
        body: TaskItemWidget(task: task, index: 0),
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

    testWidgets('should handle different task priorities', (tester) async {
      final highPriorityTask = testTask.copyWith(priority: TaskPriority.high);
      await tester.pumpWidget(createWidgetUnderTest(highPriorityTask));
      expect(find.byType(TaskItemWidget), findsOneWidget);

      final mediumPriorityTask =
          testTask.copyWith(priority: TaskPriority.medium);
      await tester.pumpWidget(createWidgetUnderTest(mediumPriorityTask));
      expect(find.byType(TaskItemWidget), findsOneWidget);

      final lowPriorityTask = testTask.copyWith(priority: TaskPriority.low);
      await tester.pumpWidget(createWidgetUnderTest(lowPriorityTask));
      expect(find.byType(TaskItemWidget), findsOneWidget);
    });

    testWidgets('should handle different task statuses', (tester) async {
      final pendingTask = testTask.copyWith(status: TaskStatus.pending);
      await tester.pumpWidget(createWidgetUnderTest(pendingTask));
      expect(find.text('Pendiente'), findsOneWidget);

      final inProgressTask = testTask.copyWith(status: TaskStatus.inProgress);
      await tester.pumpWidget(createWidgetUnderTest(inProgressTask));
      expect(find.text('En Progreso'), findsOneWidget);

      final cancelledTask = testTask.copyWith(status: TaskStatus.cancelled);
      await tester.pumpWidget(createWidgetUnderTest(cancelledTask));
      expect(find.text('Cancelada'), findsOneWidget);
    });

    testWidgets('should handle task with no tags', (tester) async {
      final noTagsTask = testTask.copyWith(tags: []);
      await tester.pumpWidget(createWidgetUnderTest(noTagsTask));
      expect(find.byType(TaskItemWidget), findsOneWidget);
    });

    testWidgets('should handle task with many tags', (tester) async {
      final manyTagsTask = testTask.copyWith(
        tags: ['tag1', 'tag2', 'tag3', 'tag4', 'tag5'],
      );
      await tester.pumpWidget(createWidgetUnderTest(manyTagsTask));
      expect(find.text('tag1'), findsOneWidget);
      expect(find.text('tag2'), findsOneWidget);
    });

    testWidgets('should display priority indicator', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testTask));
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should handle long title text', (tester) async {
      final longTitleTask = testTask.copyWith(
        title: 'This is a very long task title that might overflow',
      );
      await tester.pumpWidget(createWidgetUnderTest(longTitleTask));
      expect(find.byType(TaskItemWidget), findsOneWidget);
    });

    testWidgets('should handle long description text', (tester) async {
      final longDescTask = testTask.copyWith(
        description:
            'This is a very long task description that contains a lot of text and might overflow the widget boundaries',
      );
      await tester.pumpWidget(createWidgetUnderTest(longDescTask));
      expect(find.byType(TaskItemWidget), findsOneWidget);
    });

    testWidgets('should handle empty assigned user', (tester) async {
      final noUserTask = testTask.copyWith(assignedUser: '');
      await tester.pumpWidget(createWidgetUnderTest(noUserTask));
      expect(find.byType(TaskItemWidget), findsOneWidget);
    });

    testWidgets('should display correct checkbox state for completed task',
        (tester) async {
      final completedTask = testTask.copyWith(status: TaskStatus.completed);
      await tester.pumpWidget(createWidgetUnderTest(completedTask));

      final checkbox = find.byType(Checkbox);
      expect(checkbox, findsOneWidget);

      final checkboxWidget = tester.widget<Checkbox>(checkbox);
      expect(checkboxWidget.value, isTrue);
    });

    testWidgets('should display status icon', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(testTask));
      expect(find.byType(Icon), findsWidgets);
    });
  });
}
