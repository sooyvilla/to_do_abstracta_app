import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';

/// Contrato del repositorio para la gestión de tareas.
///
/// Define la interfaz que debe implementar cualquier repositorio
/// de tareas, proporcionando operaciones CRUD básicas, filtros
/// por estado, búsqueda y capacidades de observación en tiempo real.
abstract class TaskRepository {
  /// Obtiene todas las tareas almacenadas.
  Future<List<Task>> getAllTasks();

  /// Obtiene una tarea específica por su ID.
  ///
  /// Retorna `null` si la tarea no existe.
  Future<Task?> getTaskById(String id);

  /// Crea una nueva tarea.
  Future<void> createTask(Task task);

  /// Actualiza una tarea existente.
  Future<void> updateTask(Task task);

  /// Elimina una tarea por su ID.
  Future<void> deleteTask(String id);

  /// Obtiene todas las tareas que tienen un estado específico.
  Future<List<Task>> getTasksByStatus(TaskStatus status);

  /// Busca tareas que coincidan con el query en título, descripción o etiquetas.
  Future<List<Task>> searchTasks(String query);

  /// Observa cambios en las tareas en tiempo real.
  ///
  /// Retorna un stream que emite la lista actualizada cada vez que cambia.
  Stream<List<Task>> watchTasks();
}
