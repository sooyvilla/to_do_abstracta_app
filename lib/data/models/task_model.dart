import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';

part 'task_model.g.dart';

/// Modelo de datos para persistencia de tareas usando Hive.
///
/// Esta clase representa la estructura de datos que se almacena
/// en la base de datos local Hive. Incluye todas las anotaciones
/// necesarias para la serialización y deserialización automática.
///
/// Implementa conversión bidireccional con la entidad [Task] del dominio.
@HiveType(typeId: 0)
class TaskModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final List<String> tags;

  @HiveField(4)
  final TaskStatus status;

  @HiveField(5)
  final String assignedUser;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  @HiveField(8)
  final TaskPriority priority;

  const TaskModel({
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

  /// Convierte el modelo de datos a una entidad del dominio.
  ///
  /// Útil para pasar datos desde la capa de persistencia
  /// hacia la capa de dominio y presentación.
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      tags: tags,
      status: status,
      assignedUser: assignedUser,
      createdAt: createdAt,
      updatedAt: updatedAt,
      priority: priority,
    );
  }

  /// Crea un modelo de datos a partir de una entidad del dominio.
  ///
  /// Útil para convertir entidades del dominio en modelos
  /// que pueden ser persistidos en la base de datos.
  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      tags: task.tags,
      status: task.status,
      assignedUser: task.assignedUser,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      priority: task.priority,
    );
  }

  /// Crea una copia del modelo con los valores especificados actualizados.
  ///
  /// Útil para actualizar propiedades específicas manteniendo
  /// la inmutabilidad del objeto.
  TaskModel copyWith({
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
    return TaskModel(
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

@HiveType(typeId: 1)
enum TaskStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  inProgress,
  @HiveField(2)
  completed,
  @HiveField(3)
  cancelled,
}

@HiveType(typeId: 2)
enum TaskPriority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
  @HiveField(3)
  urgent,
}
