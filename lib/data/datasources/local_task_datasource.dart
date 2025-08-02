import 'dart:async';

import 'package:hive/hive.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';

/// Contrato para la fuente de datos local de tareas.
///
/// Define la interfaz para acceder y manipular tareas
/// en el almacenamiento local usando Hive.
abstract class LocalTaskDatasource {
  /// Obtiene todas las tareas almacenadas localmente.
  Future<List<TaskModel>> getAllTasks();

  /// Obtiene una tarea específica por su ID.
  Future<TaskModel?> getTaskById(String id);

  /// Crea una nueva tarea en el almacenamiento local.
  Future<void> createTask(TaskModel task);

  /// Actualiza una tarea existente en el almacenamiento local.
  Future<void> updateTask(TaskModel task);

  /// Elimina una tarea del almacenamiento local.
  Future<void> deleteTask(String id);

  /// Observa cambios en las tareas almacenadas localmente.
  Stream<List<TaskModel>> watchTasks();
}

/// Implementación de la fuente de datos local usando Hive.
///
/// Proporciona operaciones CRUD sobre las tareas almacenadas
/// en una base de datos local Hive, con manejo de errores
/// y capacidades de observación en tiempo real.
class LocalTaskDatasourceImpl implements LocalTaskDatasource {
  final Box<TaskModel> _box;

  LocalTaskDatasourceImpl(this._box);

  @override
  Future<List<TaskModel>> getAllTasks() async {
    try {
      return _box.values.toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<TaskModel?> getTaskById(String id) async {
    try {
      return _box.values.cast<TaskModel?>().firstWhere(
            (task) => task?.id == id,
            orElse: () => null,
          );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createTask(TaskModel task) async {
    try {
      await _box.put(task.id, task);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    try {
      await _box.put(task.id, task);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await _box.delete(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<TaskModel>> watchTasks() {
    try {
      final initialTasks = _box.values.toList();
      late StreamController<List<TaskModel>> controller;

      controller = StreamController<List<TaskModel>>(
        onListen: () {
          controller.add(initialTasks);

          final subscription = _box.watch().listen((_) {
            final tasks = _box.values.toList();
            if (!controller.isClosed) {
              controller.add(tasks);
            }
          });

          controller.onCancel = () {
            subscription.cancel();
          };
        },
      );

      return controller.stream;
    } catch (e) {
      return Stream.error(e);
    }
  }
}
