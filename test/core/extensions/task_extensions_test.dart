import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_abstracta_app/core/extensions/task_extensions.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';

void main() {
  group('TaskStatusExtension', () {
    test('should return correct color for each status', () {
      expect(TaskStatus.pending.color, equals(Colors.orange));
      expect(TaskStatus.inProgress.color, equals(Colors.blue));
      expect(TaskStatus.completed.color, equals(Colors.green));
      expect(TaskStatus.cancelled.color, equals(Colors.red));
    });

    test('should return correct label for each status', () {
      expect(TaskStatus.pending.label, equals('Pendiente'));
      expect(TaskStatus.inProgress.label, equals('En Progreso'));
      expect(TaskStatus.completed.label, equals('Completada'));
      expect(TaskStatus.cancelled.label, equals('Cancelada'));
    });

    test('should return correct icon for each status', () {
      expect(TaskStatus.pending.icon, equals(Icons.pending));
      expect(TaskStatus.inProgress.icon, equals(Icons.hourglass_empty));
      expect(TaskStatus.completed.icon, equals(Icons.check_circle));
      expect(TaskStatus.cancelled.icon, equals(Icons.cancel));
    });
  });

  group('TaskPriorityExtension', () {
    test('should return correct color for each priority', () {
      expect(TaskPriority.low.color, equals(Colors.green));
      expect(TaskPriority.medium.color, equals(Colors.orange));
      expect(TaskPriority.high.color, equals(Colors.red));
      expect(TaskPriority.urgent.color, equals(Colors.purple));
    });

    test('should return correct label for each priority', () {
      expect(TaskPriority.low.label, equals('Baja'));
      expect(TaskPriority.medium.label, equals('Media'));
      expect(TaskPriority.high.label, equals('Alta'));
      expect(TaskPriority.urgent.label, equals('Urgente'));
    });

    test('should return correct icon for each priority', () {
      expect(TaskPriority.low.icon, equals(Icons.keyboard_arrow_down));
      expect(TaskPriority.medium.icon, equals(Icons.remove));
      expect(TaskPriority.high.icon, equals(Icons.keyboard_arrow_up));
      expect(TaskPriority.urgent.icon, equals(Icons.priority_high));
    });
  });
}
