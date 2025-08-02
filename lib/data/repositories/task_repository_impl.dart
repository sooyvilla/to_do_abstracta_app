import 'package:to_do_abstracta_app/data/datasources/local_task_datasource.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';
import 'package:to_do_abstracta_app/domain/repositories/task_repository.dart';

/// Implementación del repositorio de tareas.
///
/// Actúa como intermediario entre la capa de dominio y la fuente de datos local,
/// convirtiendo entre entidades del dominio y modelos de datos.
/// Maneja todas las operaciones CRUD y proporciona manejo de errores.
class TaskRepositoryImpl implements TaskRepository {
  final LocalTaskDatasource _localDatasource;

  TaskRepositoryImpl(this._localDatasource);

  @override
  Future<List<Task>> getAllTasks() async {
    try {
      final taskModels = await _localDatasource.getAllTasks();
      return taskModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Task?> getTaskById(String id) async {
    try {
      final taskModel = await _localDatasource.getTaskById(id);
      return taskModel?.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await _localDatasource.createTask(taskModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await _localDatasource.updateTask(taskModel);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await _localDatasource.deleteTask(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Task>> getTasksByStatus(TaskStatus status) async {
    try {
      final tasks = await getAllTasks();
      return tasks.where((task) => task.status == status).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Task>> searchTasks(String query) async {
    try {
      final tasks = await getAllTasks();
      final lowercaseQuery = query.toLowerCase();

      return tasks.where((task) {
        return task.title.toLowerCase().contains(lowercaseQuery) ||
            task.description.toLowerCase().contains(lowercaseQuery) ||
            task.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Stream<List<Task>> watchTasks() {
    try {
      return _localDatasource.watchTasks().map(
            (taskModels) =>
                taskModels.map((model) => model.toEntity()).toList(),
          );
    } catch (e) {
      return Stream.value([]);
    }
  }
}
