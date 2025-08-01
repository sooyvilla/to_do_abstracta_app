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
  });
}
