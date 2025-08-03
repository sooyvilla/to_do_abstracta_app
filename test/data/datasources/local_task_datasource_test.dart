import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:to_do_abstracta_app/data/datasources/local_task_datasource.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';

import 'local_task_datasource_test.mocks.dart';

@GenerateMocks([Box])
void main() {
  late LocalTaskDatasourceImpl datasource;
  late MockBox<TaskModel> mockBox;

  setUp(() {
    mockBox = MockBox<TaskModel>();
    datasource = LocalTaskDatasourceImpl(mockBox);
  });

  group('LocalTaskDatasourceImpl', () {
    test('should get all tasks from hive box', () async {
      // Arrange
      final taskModels = [
        TaskModel(
          id: '1',
          title: 'Test Task 1',
          description: 'Description 1',
          tags: const ['tag1'],
          status: TaskStatus.pending,
          assignedUser: 'user1',
          createdAt: DateTime.now(),
          priority: TaskPriority.medium,
        ),
        TaskModel(
          id: '2',
          title: 'Test Task 2',
          description: 'Description 2',
          tags: const ['tag2'],
          status: TaskStatus.completed,
          assignedUser: 'user2',
          createdAt: DateTime.now(),
          priority: TaskPriority.high,
        ),
      ];
      when(mockBox.values).thenReturn(taskModels);

      // Act
      final result = await datasource.getAllTasks();

      // Assert
      expect(result, taskModels);
      verify(mockBox.values).called(1);
    });

    test('should return empty list when exception occurs', () async {
      // Arrange
      when(mockBox.values).thenThrow(Exception('Database error'));

      // Act
      final result = await datasource.getAllTasks();

      // Assert
      expect(result, isEmpty);
    });

    test('should get task by id', () async {
      // Arrange
      final taskModel = TaskModel(
        id: '1',
        title: 'Test Task',
        description: 'Description',
        tags: const ['tag1'],
        status: TaskStatus.pending,
        assignedUser: 'user1',
        createdAt: DateTime.now(),
        priority: TaskPriority.medium,
      );
      when(mockBox.values).thenReturn([taskModel]);

      // Act
      final result = await datasource.getTaskById('1');

      // Assert
      expect(result, taskModel);
    });

    test('should return null when task not found', () async {
      // Arrange
      when(mockBox.values).thenReturn([]);

      // Act
      final result = await datasource.getTaskById('nonexistent');

      // Assert
      expect(result, isNull);
    });

    test('should create task in hive box', () async {
      // Arrange
      final taskModel = TaskModel(
        id: '1',
        title: 'Test Task',
        description: 'Description',
        tags: const ['tag1'],
        status: TaskStatus.pending,
        assignedUser: 'user1',
        createdAt: DateTime.now(),
        priority: TaskPriority.medium,
      );
      when(mockBox.put(any, any)).thenAnswer((_) async => Future<void>.value());

      // Act
      await datasource.createTask(taskModel);

      // Assert
      verify(mockBox.put(taskModel.id, taskModel)).called(1);
    });

    test('should update task in hive box', () async {
      // Arrange
      final taskModel = TaskModel(
        id: '1',
        title: 'Updated Task',
        description: 'Updated Description',
        tags: const ['tag1'],
        status: TaskStatus.completed,
        assignedUser: 'user1',
        createdAt: DateTime.now(),
        priority: TaskPriority.high,
      );
      when(mockBox.put(any, any)).thenAnswer((_) async => Future<void>.value());

      // Act
      await datasource.updateTask(taskModel);

      // Assert
      verify(mockBox.put(taskModel.id, taskModel)).called(1);
    });

    test('should delete task from hive box', () async {
      // Arrange
      const taskId = '1';
      when(mockBox.delete(any)).thenAnswer((_) async => Future<void>.value());

      // Act
      await datasource.deleteTask(taskId);

      // Assert
      verify(mockBox.delete(taskId)).called(1);
    });

    test('should throw exception when create task fails', () async {
      // Arrange
      final taskModel = TaskModel(
        id: '1',
        title: 'Test Task',
        description: 'Description',
        tags: const ['tag1'],
        status: TaskStatus.pending,
        assignedUser: 'user1',
        createdAt: DateTime.now(),
        priority: TaskPriority.medium,
      );
      when(mockBox.put(any, any)).thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => datasource.createTask(taskModel),
        throwsException,
      );
    });

    test('should handle update task exception gracefully', () async {
      // Arrange
      final taskModel = TaskModel(
        id: '1',
        title: 'Updated Task',
        description: 'Updated Description',
        tags: const ['tag1'],
        status: TaskStatus.completed,
        assignedUser: 'user1',
        createdAt: DateTime.now(),
        priority: TaskPriority.high,
      );
      when(mockBox.put(any, any)).thenThrow(Exception('Update failed'));

      // Act & Assert
      expect(
        () => datasource.updateTask(taskModel),
        throwsException,
      );
    });

    test('should handle delete task exception gracefully', () async {
      // Arrange
      when(mockBox.delete(any)).thenThrow(Exception('Delete failed'));

      // Act & Assert
      expect(
        () => datasource.deleteTask('1'),
        throwsException,
      );
    });

    test('should handle getAllTasks with multiple tasks', () async {
      // Arrange
      final task1 = TaskModel(
        id: '1',
        title: 'Task 1',
        description: 'Description 1',
        tags: const ['tag1'],
        status: TaskStatus.pending,
        assignedUser: 'user1',
        createdAt: DateTime.now(),
        priority: TaskPriority.low,
      );
      final task2 = TaskModel(
        id: '2',
        title: 'Task 2',
        description: 'Description 2',
        tags: const ['tag2'],
        status: TaskStatus.inProgress,
        assignedUser: 'user2',
        createdAt: DateTime.now(),
        priority: TaskPriority.high,
      );
      when(mockBox.values).thenReturn([task1, task2]);

      // Act
      final result = await datasource.getAllTasks();

      // Assert
      expect(result, hasLength(2));
      expect(result, contains(task1));
      expect(result, contains(task2));
    });

    test('should get correct task by id from multiple tasks', () async {
      // Arrange
      final task1 = TaskModel(
        id: '1',
        title: 'Task 1',
        description: 'Description 1',
        tags: const ['tag1'],
        status: TaskStatus.pending,
        assignedUser: 'user1',
        createdAt: DateTime.now(),
        priority: TaskPriority.low,
      );
      final task2 = TaskModel(
        id: '2',
        title: 'Task 2',
        description: 'Description 2',
        tags: const ['tag2'],
        status: TaskStatus.inProgress,
        assignedUser: 'user2',
        createdAt: DateTime.now(),
        priority: TaskPriority.high,
      );
      when(mockBox.values).thenReturn([task1, task2]);

      // Act
      final result = await datasource.getTaskById('2');

      // Assert
      expect(result, task2);
      expect(result?.id, '2');
    });

    test('should watch tasks and emit changes', () async {
      // Arrange
      final taskModel = TaskModel(
        id: '1',
        title: 'Test Task',
        description: 'Description',
        tags: const ['tag1'],
        status: TaskStatus.pending,
        assignedUser: 'user1',
        createdAt: DateTime.now(),
        priority: TaskPriority.medium,
      );

      when(mockBox.values).thenReturn([taskModel]);
      when(mockBox.watch()).thenAnswer(
          (_) => Stream.fromIterable([])); // Empty stream for BoxEvent

      // Act
      final stream = datasource.watchTasks();
      final firstEmission = await stream.first;

      // Assert
      expect(firstEmission.length, 1);
      expect(firstEmission.first.id, '1');
      verify(mockBox.values).called(greaterThan(0));
    });

    test('should handle stream errors in watchTasks', () async {
      // Arrange
      when(mockBox.values).thenThrow(Exception('Database error'));

      // Act
      final stream = datasource.watchTasks();

      // Assert
      expect(stream, emitsError(isA<Exception>()));
    });

    test('should handle exception in getTaskById', () async {
      // Arrange
      when(mockBox.values).thenThrow(Exception('Database error'));

      // Act
      final result = await datasource.getTaskById('test-id');

      // Assert
      expect(result, isNull);
    });
  });
}
