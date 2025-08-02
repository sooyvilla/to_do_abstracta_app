import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_abstracta_app/domain/usecases/task_usecases.dart';

void main() {
  group('TaskStatistics', () {
    test('should calculate completion rate correctly with tasks', () {
      final statistics = TaskStatistics(
        total: 10,
        completed: 7,
        pending: 2,
        inProgress: 1,
        cancelled: 0,
      );

      expect(statistics.completionRate, equals(0.7));
    });

    test('should return 0 completion rate when no tasks exist', () {
      final statistics = TaskStatistics(
        total: 0,
        completed: 0,
        pending: 0,
        inProgress: 0,
        cancelled: 0,
      );

      expect(statistics.completionRate, equals(0.0));
    });

    test('should handle edge case with only completed tasks', () {
      final statistics = TaskStatistics(
        total: 5,
        completed: 5,
        pending: 0,
        inProgress: 0,
        cancelled: 0,
      );

      expect(statistics.completionRate, equals(1.0));
    });
  });
}
