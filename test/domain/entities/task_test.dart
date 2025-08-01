import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';

void main() {
  group('Task Entity', () {
    late Task task;

    setUp(() {
      task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        tags: const ['work', 'urgent'],
        status: TaskStatus.pending,
        assignedUser: 'test@example.com',
        createdAt: DateTime(2024, 1, 1),
        priority: TaskPriority.high,
      );
    });

    test('should create Task with all properties', () {
      expect(task.id, equals('1'));
      expect(task.title, equals('Test Task'));
      expect(task.description, equals('Test Description'));
      expect(task.tags, equals(['work', 'urgent']));
      expect(task.status, equals(TaskStatus.pending));
      expect(task.assignedUser, equals('test@example.com'));
      expect(task.createdAt, equals(DateTime(2024, 1, 1)));
      expect(task.updatedAt, isNull);
      expect(task.priority, equals(TaskPriority.high));
    });

    test('should create Task with updatedAt', () {
      final updatedDate = DateTime(2024, 1, 2);
      final taskWithUpdate = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        tags: const ['work'],
        status: TaskStatus.pending,
        assignedUser: 'test@example.com',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: updatedDate,
        priority: TaskPriority.medium,
      );

      expect(taskWithUpdate.updatedAt, equals(updatedDate));
    });

    test('should create copy with updated properties', () {
      final updatedTask = task.copyWith(
        title: 'Updated Task',
        status: TaskStatus.completed,
      );

      expect(updatedTask.title, equals('Updated Task'));
      expect(updatedTask.status, equals(TaskStatus.completed));
      expect(updatedTask.id, equals(task.id)); // unchanged
      expect(updatedTask.description, equals(task.description)); // unchanged
    });

    test('should create copy with all properties updated', () {
      final newDate = DateTime(2024, 2, 1);
      final updatedTask = task.copyWith(
        id: '2',
        title: 'New Title',
        description: 'New Description',
        tags: ['personal'],
        status: TaskStatus.inProgress,
        assignedUser: 'new@example.com',
        createdAt: newDate,
        updatedAt: newDate,
        priority: TaskPriority.low,
      );

      expect(updatedTask.id, equals('2'));
      expect(updatedTask.title, equals('New Title'));
      expect(updatedTask.description, equals('New Description'));
      expect(updatedTask.tags, equals(['personal']));
      expect(updatedTask.status, equals(TaskStatus.inProgress));
      expect(updatedTask.assignedUser, equals('new@example.com'));
      expect(updatedTask.createdAt, equals(newDate));
      expect(updatedTask.updatedAt, equals(newDate));
      expect(updatedTask.priority, equals(TaskPriority.low));
    });

    test('should correctly identify completed status', () {
      final completedTask = task.copyWith(status: TaskStatus.completed);

      expect(completedTask.isCompleted, isTrue);
      expect(task.isCompleted, isFalse);
    });

    test('should correctly identify pending status', () {
      expect(task.isPending, isTrue);

      final inProgressTask = task.copyWith(status: TaskStatus.inProgress);
      expect(inProgressTask.isPending, isFalse);
    });

    test('should correctly identify in progress status', () {
      final inProgressTask = task.copyWith(status: TaskStatus.inProgress);

      expect(inProgressTask.isInProgress, isTrue);
      expect(task.isInProgress, isFalse);
    });

    test('should correctly identify cancelled status', () {
      final cancelledTask = task.copyWith(status: TaskStatus.cancelled);

      expect(cancelledTask.isCancelled, isTrue);
      expect(task.isCancelled, isFalse);
    });

    test('should support equality comparison', () {
      final task1 = Task(
        id: '1',
        title: 'Task',
        description: 'Description',
        tags: const ['work'],
        status: TaskStatus.pending,
        assignedUser: 'user@test.com',
        createdAt: DateTime(2024, 1, 1),
        priority: TaskPriority.medium,
      );

      final task2 = Task(
        id: '1',
        title: 'Task',
        description: 'Description',
        tags: const ['work'],
        status: TaskStatus.pending,
        assignedUser: 'user@test.com',
        createdAt: DateTime(2024, 1, 1),
        priority: TaskPriority.medium,
      );

      final task3 = task1.copyWith(title: 'Different Task');

      expect(task1, equals(task2));
      expect(task1, isNot(equals(task3)));
    });

    test('should have correct props for equality', () {
      expect(task.props, contains(task.id));
      expect(task.props, contains(task.title));
      expect(task.props, contains(task.description));
      expect(task.props, contains(task.tags));
      expect(task.props, contains(task.status));
      expect(task.props, contains(task.assignedUser));
      expect(task.props, contains(task.createdAt));
      expect(task.props, contains(task.updatedAt));
      expect(task.props, contains(task.priority));
    });
  });
}
