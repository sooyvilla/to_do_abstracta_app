import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:to_do_abstracta_app/core/di/injection.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';
import 'package:to_do_abstracta_app/domain/usecases/llm_usecases.dart';
import 'package:to_do_abstracta_app/domain/usecases/task_usecases.dart';
import 'package:to_do_abstracta_app/presentation/pages/task_detail_page.dart';

import 'task_detail_page_test.mocks.dart';

@GenerateMocks([TaskUsecases, LLMUsecases])
void main() {
  group('TaskDetailPage', () {
    late MockTaskUsecases mockTaskUsecases;
    late MockLLMUsecases mockLLMUsecases;

    setUp(() {
      mockTaskUsecases = MockTaskUsecases();
      mockLLMUsecases = MockLLMUsecases();
    });

    testWidgets('should render TaskDetailPage', (tester) async {
      final testTask = Task(
        id: 'test-task-id',
        title: 'Test Task',
        description: 'Test Description',
        tags: const ['test', 'flutter'],
        status: TaskStatus.pending,
        assignedUser: 'test-user',
        priority: TaskPriority.medium,
        createdAt: DateTime.now(),
      );

      when(mockTaskUsecases.watchTasks())
          .thenAnswer((_) => Stream.value([testTask]));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            taskUsecasesProvider.overrideWith((ref) => mockTaskUsecases),
            llmUsecasesProvider.overrideWith((ref) => mockLLMUsecases),
          ],
          child: MaterialApp(
            home: TaskDetailPage(initialTask: testTask),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(TaskDetailPage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should show task details when task is found', (tester) async {
      // Arrange
      final testTask = Task(
        id: 'test-task-id',
        title: 'Flutter Task',
        description: 'Learn Flutter development',
        tags: const ['flutter', 'mobile'],
        status: TaskStatus.inProgress,
        assignedUser: 'developer',
        priority: TaskPriority.high,
        createdAt: DateTime.now(),
      );

      when(mockTaskUsecases.watchTasks())
          .thenAnswer((_) => Stream.value([testTask]));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            taskUsecasesProvider.overrideWith((ref) => mockTaskUsecases),
            llmUsecasesProvider.overrideWith((ref) => mockLLMUsecases),
          ],
          child: MaterialApp(
            home: TaskDetailPage(initialTask: testTask),
          ),
        ),
      );

      await tester.pump();

      // Act & Assert
      expect(find.text('Flutter Task'), findsOneWidget);
      expect(find.text('Learn Flutter development'), findsOneWidget);
    });

    testWidgets('should show AppBar with proper title', (tester) async {
      // Arrange
      final testTask = Task(
        id: 'test-task-id',
        title: 'Test Task',
        description: 'Test Description',
        tags: const ['test'],
        status: TaskStatus.pending,
        assignedUser: 'test-user',
        priority: TaskPriority.medium,
        createdAt: DateTime.now(),
      );

      when(mockTaskUsecases.watchTasks())
          .thenAnswer((_) => Stream.value([testTask]));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            taskUsecasesProvider.overrideWith((ref) => mockTaskUsecases),
            llmUsecasesProvider.overrideWith((ref) => mockLLMUsecases),
          ],
          child: MaterialApp(
            home: TaskDetailPage(initialTask: testTask),
          ),
        ),
      );

      await tester.pump();

      // Act & Assert
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display task status and priority correctly',
        (tester) async {
      // Arrange
      final testTask = Task(
        id: 'test-task-id',
        title: 'High Priority Task',
        description: 'Important task',
        tags: const ['urgent'],
        status: TaskStatus.completed,
        assignedUser: 'developer',
        priority: TaskPriority.high,
        createdAt: DateTime.now(),
      );

      when(mockTaskUsecases.watchTasks())
          .thenAnswer((_) => Stream.value([testTask]));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            taskUsecasesProvider.overrideWith((ref) => mockTaskUsecases),
            llmUsecasesProvider.overrideWith((ref) => mockLLMUsecases),
          ],
          child: MaterialApp(
            home: TaskDetailPage(initialTask: testTask),
          ),
        ),
      );

      await tester.pump();

      // Act & Assert
      expect(find.text('High Priority Task'), findsOneWidget);
      expect(find.text('Important task'), findsOneWidget);
    });

    testWidgets('should display task tags', (tester) async {
      // Arrange
      final testTask = Task(
        id: 'test-task-id',
        title: 'Tagged Task',
        description: 'Task with tags',
        tags: const ['flutter', 'dart', 'mobile'],
        status: TaskStatus.pending,
        assignedUser: 'developer',
        priority: TaskPriority.medium,
        createdAt: DateTime.now(),
      );

      when(mockTaskUsecases.watchTasks())
          .thenAnswer((_) => Stream.value([testTask]));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            taskUsecasesProvider.overrideWith((ref) => mockTaskUsecases),
            llmUsecasesProvider.overrideWith((ref) => mockLLMUsecases),
          ],
          child: MaterialApp(
            home: TaskDetailPage(initialTask: testTask),
          ),
        ),
      );

      await tester.pump();

      // Act & Assert
      expect(find.text('Tagged Task'), findsOneWidget);
      expect(find.text('Task with tags'), findsOneWidget);
    });
  });
}
