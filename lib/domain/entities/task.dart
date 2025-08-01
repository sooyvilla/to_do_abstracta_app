import 'package:equatable/equatable.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';

/// Entidad que representa una tarea en el dominio de la aplicación.
///
/// Esta clase encapsula toda la información necesaria para una tarea,
/// incluyendo identificador, título, descripción, etiquetas, estado,
/// usuario asignado, fechas de creación y actualización, y prioridad.
///
/// Implementa [Equatable] para facilitar comparaciones y es inmutable.
class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<String> tags;
  final TaskStatus status;
  final String assignedUser;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final TaskPriority priority;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.status,
    required this.assignedUser,
    required this.createdAt,
    this.updatedAt,
    this.priority = TaskPriority.medium,
  });

  /// Crea una copia de la tarea con los valores proporcionados actualizados.
  ///
  /// Útil para actualizar propiedades específicas de una tarea inmutable
  /// manteniendo el resto de valores intactos.
  Task copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? tags,
    TaskStatus? status,
    String? assignedUser,
    DateTime? createdAt,
    DateTime? updatedAt,
    TaskPriority? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      assignedUser: assignedUser ?? this.assignedUser,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      priority: priority ?? this.priority,
    );
  }

  /// Verifica si la tarea está completada.
  bool get isCompleted => status == TaskStatus.completed;

  /// Verifica si la tarea está pendiente.
  bool get isPending => status == TaskStatus.pending;

  /// Verifica si la tarea está en progreso.
  bool get isInProgress => status == TaskStatus.inProgress;

  /// Verifica si la tarea ha sido cancelada.
  bool get isCancelled => status == TaskStatus.cancelled;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        tags,
        status,
        assignedUser,
        createdAt,
        updatedAt,
        priority,
      ];
}
