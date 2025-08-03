import 'package:to_do_abstracta_app/data/models/task_model.dart';

/// Modelo de datos para transferir información completa de una tarea.
///
/// Encapsula todos los datos necesarios para completar un formulario de tarea
/// incluyendo descripción, etiquetas, estado, prioridad y usuario asignado.
class TaskFormData {
  final String description;
  final List<String> tags;
  final TaskStatus status;
  final TaskPriority priority;
  final String assignedUser;

  TaskFormData({
    required this.description,
    required this.tags,
    required this.status,
    required this.priority,
    required this.assignedUser,
  });
}
