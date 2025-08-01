import 'package:flutter/material.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';

/// Extensión para [TaskStatus] que agrega propiedades de UI.
///
/// Proporciona colores, etiquetas e iconos apropiados para cada
/// estado de tarea, facilitando la representación visual consistente
/// en toda la aplicación.
extension TaskStatusExtension on TaskStatus {
  /// Color asociado con el estado de la tarea.
  Color get color {
    switch (this) {
      case TaskStatus.pending:
        return Colors.orange;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.cancelled:
        return Colors.red;
    }
  }

  /// Etiqueta de texto legible para el estado de la tarea.
  String get label {
    switch (this) {
      case TaskStatus.pending:
        return 'Pendiente';
      case TaskStatus.inProgress:
        return 'En Progreso';
      case TaskStatus.completed:
        return 'Completada';
      case TaskStatus.cancelled:
        return 'Cancelada';
    }
  }

  /// Icono representativo para el estado de la tarea.
  IconData get icon {
    switch (this) {
      case TaskStatus.pending:
        return Icons.pending;
      case TaskStatus.inProgress:
        return Icons.hourglass_empty;
      case TaskStatus.completed:
        return Icons.check_circle;
      case TaskStatus.cancelled:
        return Icons.cancel;
    }
  }
}

/// Extensión para [TaskPriority] que agrega propiedades de UI.
///
/// Proporciona colores, etiquetas e iconos apropiados para cada
/// nivel de prioridad de tarea, facilitando la representación visual
/// consistente en toda la aplicación.
extension TaskPriorityExtension on TaskPriority {
  /// Color asociado con el nivel de prioridad.
  Color get color {
    switch (this) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.urgent:
        return Colors.purple;
    }
  }

  String get label {
    switch (this) {
      case TaskPriority.low:
        return 'Baja';
      case TaskPriority.medium:
        return 'Media';
      case TaskPriority.high:
        return 'Alta';
      case TaskPriority.urgent:
        return 'Urgente';
    }
  }

  IconData get icon {
    switch (this) {
      case TaskPriority.low:
        return Icons.keyboard_arrow_down;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.keyboard_arrow_up;
      case TaskPriority.urgent:
        return Icons.priority_high;
    }
  }
}
