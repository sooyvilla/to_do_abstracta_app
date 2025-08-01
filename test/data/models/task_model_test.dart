import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';

void main() {
  group('TaskModel', () {
    test('should create TaskModel from Entity', () {
      // Arrange
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        tags: const ['tag1', 'tag2'],
        status: TaskStatus.pending,
        assignedUser: 'user1',
        createdAt: DateTime(2024, 1, 1),
        priority: TaskPriority.high,
      );

      // Act
      final taskModel = TaskModel.fromEntity(task);

      // Assert
      expect(taskModel.id, '1');
      expect(taskModel.title, 'Test Task');
      expect(taskModel.description, 'Test Description');
      expect(taskModel.tags, ['tag1', 'tag2']);
      expect(taskModel.status, TaskStatus.pending);
      expect(taskModel.assignedUser, 'user1');
      expect(taskModel.createdAt, DateTime(2024, 1, 1));
      expect(taskModel.priority, TaskPriority.high);
    });

    test('should convert TaskModel to Entity', () {
      // Arrange
      final taskModel = TaskModel(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        tags: const ['tag1', 'tag2'],
        status: TaskStatus.completed,
        assignedUser: 'user1',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
        priority: TaskPriority.medium,
      );

      // Act
      final task = taskModel.toEntity();

      // Assert
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.tags, ['tag1', 'tag2']);
      expect(task.status, TaskStatus.completed);
      expect(task.assignedUser, 'user1');
      expect(task.createdAt, DateTime(2024, 1, 1));
      expect(task.updatedAt, DateTime(2024, 1, 2));
      expect(task.priority, TaskPriority.medium);
    });

    test('should support equality comparison', () {
      // Arrange
      final taskModel1 = TaskModel(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        tags: const ['tag1'],
        status: TaskStatus.pending,
        assignedUser: 'user1',
        createdAt: DateTime(2024, 1, 1),
        priority: TaskPriority.medium,
      );

      final taskModel2 = TaskModel(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        tags: const ['tag1'],
        status: TaskStatus.pending,
        assignedUser: 'user1',
        createdAt: DateTime(2024, 1, 1),
        priority: TaskPriority.medium,
      );

      // Act & Assert
      expect(taskModel1, equals(taskModel2));
      expect(taskModel1.hashCode, equals(taskModel2.hashCode));
    });

    test('should handle copyWith method', () {
      // Arrange
      final taskModel = TaskModel(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        tags: const ['tag1'],
        status: TaskStatus.pending,
        assignedUser: 'user1',
        createdAt: DateTime(2024, 1, 1),
        priority: TaskPriority.medium,
      );

      // Act
      final updatedTaskModel = taskModel.copyWith(
        title: 'Updated Task',
        status: TaskStatus.completed,
      );

      // Assert
      expect(updatedTaskModel.id, '1');
      expect(updatedTaskModel.title, 'Updated Task');
      expect(updatedTaskModel.status, TaskStatus.completed);
      expect(updatedTaskModel.description, 'Test Description'); // Unchanged
    });
  });
}
