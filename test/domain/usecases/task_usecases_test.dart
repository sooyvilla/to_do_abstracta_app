import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';
import 'package:to_do_abstracta_app/domain/repositories/task_repository.dart';
import 'package:to_do_abstracta_app/domain/usecases/task_usecases.dart';

import 'task_usecases_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  late TaskUsecases taskUsecases;
  late MockTaskRepository mockRepository;

  setUp(() {
    mockRepository = MockTaskRepository();
    taskUsecases = TaskUsecases(mockRepository);
  });

  group('TaskUsecases', () {
    final testTask = Task(
      id: '1',
      title: 'Test Task',
      description: 'Test Description',
      tags: const ['test'],
      status: TaskStatus.pending,
      assignedUser: 'Test User',
      createdAt: DateTime.now(),
    );

    test('should get all tasks from repository', () async {
      final tasks = [testTask];
      when(mockRepository.getAllTasks()).thenAnswer((_) async => tasks);

      final result = await taskUsecases.getAllTasks();

      expect(result, equals(tasks));
      verify(mockRepository.getAllTasks()).called(1);
    });

    test('should create task through repository', () async {
      when(mockRepository.createTask(testTask)).thenAnswer((_) async {});

      await taskUsecases.createTask(testTask);

      verify(mockRepository.createTask(testTask)).called(1);
    });

    test('should toggle task status correctly', () async {
      when(mockRepository.getTaskById('1')).thenAnswer((_) async => testTask);
      when(mockRepository.updateTask(any)).thenAnswer((_) async {});

      await taskUsecases.toggleTaskStatus('1');

      verify(mockRepository.getTaskById('1')).called(1);
      verify(mockRepository.updateTask(any)).called(1);
    });

    test('should calculate task statistics correctly', () async {
      final tasks = [
        testTask,
        testTask.copyWith(id: '2', status: TaskStatus.completed),
        testTask.copyWith(id: '3', status: TaskStatus.inProgress),
      ];
      when(mockRepository.getAllTasks()).thenAnswer((_) async => tasks);

      final statistics = await taskUsecases.getTaskStatistics();

      expect(statistics.total, equals(3));
      expect(statistics.completed, equals(1));
      expect(statistics.pending, equals(1));
      expect(statistics.inProgress, equals(1));
      expect(statistics.completionRate, closeTo(0.33, 0.01));
    });

    test('should search tasks correctly', () async {
      when(mockRepository.searchTasks('Test'))
          .thenAnswer((_) async => [testTask]);

      final result = await taskUsecases.searchTasks('Test');

      expect(result, equals([testTask]));
      verify(mockRepository.searchTasks('Test')).called(1);
    });

    test('should get task by id through repository', () async {
      when(mockRepository.getTaskById('1')).thenAnswer((_) async => testTask);

      final result = await taskUsecases.getTaskById('1');

      expect(result, equals(testTask));
      verify(mockRepository.getTaskById('1')).called(1);
    });

    test('should return null when task not found by id', () async {
      when(mockRepository.getTaskById('nonexistent'))
          .thenAnswer((_) async => null);

      final result = await taskUsecases.getTaskById('nonexistent');

      expect(result, isNull);
      verify(mockRepository.getTaskById('nonexistent')).called(1);
    });

    test('should update task through repository', () async {
      final updatedTask = testTask.copyWith(title: 'Updated Title');
      when(mockRepository.updateTask(updatedTask)).thenAnswer((_) async {});

      await taskUsecases.updateTask(updatedTask);

      verify(mockRepository.updateTask(updatedTask)).called(1);
    });

    test('should delete task through repository', () async {
      when(mockRepository.deleteTask('1')).thenAnswer((_) async {});

      await taskUsecases.deleteTask('1');

      verify(mockRepository.deleteTask('1')).called(1);
    });

    test('should watch tasks from repository', () async {
      final taskStream = Stream.value([testTask]);
      when(mockRepository.watchTasks()).thenAnswer((_) => taskStream);

      final result = taskUsecases.watchTasks();

      expect(result, equals(taskStream));
      verify(mockRepository.watchTasks()).called(1);
    });

    test('should handle toggle task status when task not found', () async {
      when(mockRepository.getTaskById('nonexistent'))
          .thenAnswer((_) async => null);

      // This should not throw and should not call updateTask
      await taskUsecases.toggleTaskStatus('nonexistent');

      verify(mockRepository.getTaskById('nonexistent')).called(1);
      verifyNever(mockRepository.updateTask(any));
    });

    test('should calculate statistics with empty task list', () async {
      when(mockRepository.getAllTasks()).thenAnswer((_) async => []);

      final statistics = await taskUsecases.getTaskStatistics();

      expect(statistics.total, equals(0));
      expect(statistics.completed, equals(0));
      expect(statistics.pending, equals(0));
      expect(statistics.inProgress, equals(0));
      expect(statistics.completionRate, equals(0.0));
    });

    test('should calculate statistics with all completed tasks', () async {
      final completedTasks = [
        testTask.copyWith(id: '1', status: TaskStatus.completed),
        testTask.copyWith(id: '2', status: TaskStatus.completed),
      ];
      when(mockRepository.getAllTasks())
          .thenAnswer((_) async => completedTasks);

      final statistics = await taskUsecases.getTaskStatistics();

      expect(statistics.total, equals(2));
      expect(statistics.completed, equals(2));
      expect(statistics.pending, equals(0));
      expect(statistics.inProgress, equals(0));
      expect(statistics.completionRate, equals(1.0));
    });

    test('should toggle task from pending to completed', () async {
      final pendingTask = testTask.copyWith(status: TaskStatus.pending);
      when(mockRepository.getTaskById('1'))
          .thenAnswer((_) async => pendingTask);
      when(mockRepository.updateTask(any)).thenAnswer((_) async {});

      await taskUsecases.toggleTaskStatus('1');

      final captured = verify(mockRepository.updateTask(captureAny)).captured;
      final updatedTask = captured.first as Task;
      expect(updatedTask.status, TaskStatus.completed);
    });

    test('should toggle task from completed to pending', () async {
      final completedTask = testTask.copyWith(status: TaskStatus.completed);
      when(mockRepository.getTaskById('1'))
          .thenAnswer((_) async => completedTask);
      when(mockRepository.updateTask(any)).thenAnswer((_) async {});

      await taskUsecases.toggleTaskStatus('1');

      final captured = verify(mockRepository.updateTask(captureAny)).captured;
      final updatedTask = captured.first as Task;
      expect(updatedTask.status, TaskStatus.pending);
    });

    test('should count cancelled tasks in statistics', () async {
      final tasks = [
        testTask.copyWith(id: '1', status: TaskStatus.pending),
        testTask.copyWith(id: '2', status: TaskStatus.completed),
        testTask.copyWith(id: '3', status: TaskStatus.inProgress),
        testTask.copyWith(id: '4', status: TaskStatus.cancelled),
      ];
      when(mockRepository.getAllTasks()).thenAnswer((_) async => tasks);

      final statistics = await taskUsecases.getTaskStatistics();

      expect(statistics.total, equals(4));
      expect(statistics.completed, equals(1));
      expect(statistics.pending, equals(1));
      expect(statistics.inProgress, equals(1));
      expect(statistics.cancelled, equals(1));
      expect(statistics.completionRate, equals(0.25));
    });
  });
}
