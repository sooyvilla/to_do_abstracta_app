import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';
import 'package:to_do_abstracta_app/domain/repositories/task_repository.dart';

/// Casos de uso para la gestión de tareas.
///
/// Esta clase encapsula toda la lógica de negocio relacionada con las tareas,
/// actuando como intermediario entre la capa de presentación y el repositorio.
/// Implementa operaciones CRUD básicas y funcionalidades adicionales como
/// estadísticas y búsqueda de tareas.
class TaskUsecases {
  final TaskRepository _repository;

  TaskUsecases(this._repository);

  /// Obtiene todas las tareas del repositorio.
  Future<List<Task>> getAllTasks() => _repository.getAllTasks();

  /// Obtiene una tarea específica por su ID.
  ///
  /// Retorna `null` si la tarea no existe.
  Future<Task?> getTaskById(String id) => _repository.getTaskById(id);

  /// Crea una nueva tarea en el repositorio.
  Future<void> createTask(Task task) => _repository.createTask(task);

  /// Actualiza una tarea existente en el repositorio.
  Future<void> updateTask(Task task) => _repository.updateTask(task);

  /// Elimina una tarea del repositorio por su ID.
  Future<void> deleteTask(String id) => _repository.deleteTask(id);

  /// Cambia el estado de una tarea entre completada y pendiente.
  ///
  /// Si la tarea está completada, la marca como pendiente.
  /// Si la tarea está pendiente, la marca como completada.
  /// También actualiza la fecha de modificación.
  Future<void> toggleTaskStatus(String id) async {
    final task = await _repository.getTaskById(id);
    if (task != null) {
      final newStatus = task.status == TaskStatus.completed
          ? TaskStatus.pending
          : TaskStatus.completed;

      final updatedTask = task.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );

      await _repository.updateTask(updatedTask);
    }
  }

  /// Calcula y retorna estadísticas sobre las tareas.
  ///
  /// Incluye contadores para el total de tareas, tareas completadas,
  /// pendientes, en progreso y canceladas, así como la tasa de finalización.
  Future<TaskStatistics> getTaskStatistics() async {
    final tasks = await _repository.getAllTasks();

    final completed = tasks.where((task) => task.isCompleted).length;
    final pending = tasks.where((task) => task.isPending).length;
    final inProgress = tasks.where((task) => task.isInProgress).length;
    final cancelled = tasks.where((task) => task.isCancelled).length;

    return TaskStatistics(
      total: tasks.length,
      completed: completed,
      pending: pending,
      inProgress: inProgress,
      cancelled: cancelled,
    );
  }

  /// Observa cambios en la lista de tareas en tiempo real.
  ///
  /// Retorna un stream que emite la lista actualizada de tareas
  /// cada vez que ocurre un cambio en el repositorio.
  Stream<List<Task>> watchTasks() => _repository.watchTasks();

  /// Busca tareas que coincidan con el query proporcionado.
  ///
  /// La búsqueda se realiza en títulos, descripciones y etiquetas.
  Future<List<Task>> searchTasks(String query) =>
      _repository.searchTasks(query);
}

/// Clase que encapsula las estadísticas de las tareas.
///
/// Proporciona contadores para diferentes estados de tareas
/// y calcula métricas como la tasa de finalización.
class TaskStatistics {
  final int total;
  final int completed;
  final int pending;
  final int inProgress;
  final int cancelled;

  TaskStatistics({
    required this.total,
    required this.completed,
    required this.pending,
    required this.inProgress,
    required this.cancelled,
  });

  /// Calcula la tasa de finalización como un porcentaje (0.0 a 1.0).
  ///
  /// Retorna 0.0 si no hay tareas en total.
  double get completionRate => total > 0 ? completed / total : 0.0;
}
