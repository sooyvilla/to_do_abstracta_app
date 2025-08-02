import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:to_do_abstracta_app/data/datasources/local_task_datasource.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/data/repositories/task_repository_impl.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';

import 'task_repository_impl_test.mocks.dart';

@GenerateMocks([LocalTaskDatasource])
void main() {
  late TaskRepositoryImpl repository;
  late MockLocalTaskDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockLocalTaskDatasource();
    repository = TaskRepositoryImpl(mockDatasource);
  });

  group('TaskRepositoryImpl', () {
    test('should get all tasks from datasource', () async {
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
      when(mockDatasource.getAllTasks()).thenAnswer((_) async => taskModels);

      // Act
      final result = await repository.getAllTasks();

      // Assert
      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[1].id, '2');
      verify(mockDatasource.getAllTasks()).called(1);
    });

    test('should get task by id from datasource', () async {
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
      when(mockDatasource.getTaskById('1')).thenAnswer((_) async => taskModel);

      // Act
      final result = await repository.getTaskById('1');

      // Assert
      expect(result?.id, '1');
      expect(result?.title, 'Test Task');
      verify(mockDatasource.getTaskById('1')).called(1);
    });

    test('should return null when task not found', () async {
      // Arrange
      when(mockDatasource.getTaskById('nonexistent'))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getTaskById('nonexistent');

      // Assert
      expect(result, isNull);
      verify(mockDatasource.getTaskById('nonexistent')).called(1);
    });

    test('should create task through datasource', () async {
      // Arrange
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Description',
        tags: const ['tag1'],
        status: TaskStatus.pending,
        assignedUser: 'user1',
        createdAt: DateTime.now(),
        priority: TaskPriority.medium,
      );
      when(mockDatasource.createTask(any))
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await repository.createTask(task);

      // Assert
      verify(mockDatasource.createTask(any)).called(1);
    });

    test('should update task through datasource', () async {
      // Arrange
      final task = Task(
        id: '1',
        title: 'Updated Task',
        description: 'Updated Description',
        tags: const ['tag1'],
        status: TaskStatus.completed,
        assignedUser: 'user1',
        createdAt: DateTime.now(),
        priority: TaskPriority.high,
      );
      when(mockDatasource.updateTask(any))
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await repository.updateTask(task);

      // Assert
      verify(mockDatasource.updateTask(any)).called(1);
    });

    test('should delete task through datasource', () async {
      // Arrange
      const taskId = '1';
      when(mockDatasource.deleteTask(taskId))
          .thenAnswer((_) async => Future<void>.value());

      // Act
      await repository.deleteTask(taskId);

      // Assert
      verify(mockDatasource.deleteTask(taskId)).called(1);
    });

    test('should watch tasks from datasource', () async {
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
      when(mockDatasource.watchTasks())
          .thenAnswer((_) => Stream.value([taskModel]));

      // Act
      final stream = repository.watchTasks();

      // Assert
      await expectLater(
        stream,
        emits(isA<List<Task>>().having((list) => list.length, 'length', 1)),
      );
      verify(mockDatasource.watchTasks()).called(1);
    });

    test('should handle empty stream in watchTasks', () async {
      // Arrange
      when(mockDatasource.watchTasks()).thenAnswer((_) => Stream.value([]));

      // Act
      final stream = repository.watchTasks();

      // Assert
      await expectLater(
        stream,
        emits(isA<List<Task>>().having((list) => list.length, 'length', 0)),
      );
    });

    test('should handle stream errors in watchTasks', () async {
      // Arrange
      when(mockDatasource.watchTasks())
          .thenAnswer((_) => Stream.error(Exception('Stream error')));

      // Act
      final stream = repository.watchTasks();

      // Assert
      expect(stream, emitsError(isA<Exception>()));
    });

    test('should transform multiple task models correctly', () async {
      // Arrange
      final taskModel1 = TaskModel(
        id: '1',
        title: 'Task 1',
        description: 'Description 1',
        tags: const ['tag1'],
        status: TaskStatus.pending,
        assignedUser: 'user1',
        createdAt: DateTime.now(),
        priority: TaskPriority.medium,
      );

      final taskModel2 = TaskModel(
        id: '2',
        title: 'Task 2',
        description: 'Description 2',
        tags: const ['tag2'],
        status: TaskStatus.completed,
        assignedUser: 'user2',
        createdAt: DateTime.now(),
        priority: TaskPriority.high,
      );

      when(mockDatasource.getAllTasks())
          .thenAnswer((_) async => [taskModel1, taskModel2]);

      // Act
      final result = await repository.getAllTasks();

      // Assert
      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[0].title, 'Task 1');
      expect(result[1].id, '2');
      expect(result[1].title, 'Task 2');
    });

    test('should handle exceptions in createTask', () async {
      // Arrange
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Description',
        tags: const ['tag1'],
        status: TaskStatus.pending,
        assignedUser: 'user1',
        createdAt: DateTime.now(),
        priority: TaskPriority.medium,
      );
      when(mockDatasource.createTask(any)).thenThrow(Exception('Create error'));

      // Act & Assert
      expect(() => repository.createTask(task), throwsA(isA<Exception>()));
    });

    test('should handle exceptions in updateTask', () async {
      // Arrange
      final task = Task(
        id: '1',
        title: 'Updated Task',
        description: 'Updated Description',
        tags: const ['tag1'],
        status: TaskStatus.completed,
        assignedUser: 'user1',
        createdAt: DateTime.now(),
        priority: TaskPriority.high,
      );
      when(mockDatasource.updateTask(any)).thenThrow(Exception('Update error'));

      // Act & Assert
      expect(() => repository.updateTask(task), throwsA(isA<Exception>()));
    });

    test('should handle exceptions in deleteTask', () async {
      // Arrange
      when(mockDatasource.deleteTask('1')).thenThrow(Exception('Delete error'));

      // Act & Assert
      expect(() => repository.deleteTask('1'), throwsA(isA<Exception>()));
    });
  });
}
