import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_abstracta_app/data/datasources/llm_datasource.dart';
import 'package:to_do_abstracta_app/data/datasources/local_task_datasource.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/data/repositories/llm_repository_impl.dart';
import 'package:to_do_abstracta_app/data/repositories/task_repository_impl.dart';
import 'package:to_do_abstracta_app/domain/repositories/llm_repository.dart';
import 'package:to_do_abstracta_app/domain/repositories/task_repository.dart';
import 'package:to_do_abstracta_app/domain/usecases/llm_usecases.dart';
import 'package:to_do_abstracta_app/domain/usecases/task_usecases.dart';

/// Proveedor para la DB tareas.
///
/// Proporciona acceso a la base de datos local de tareas.
final hiveBoxProvider = Provider<Box<TaskModel>>((ref) {
  if (!Hive.isBoxOpen('tasks')) {
    throw Exception(
        'Hive box is not open. Make sure to call setupDependencies() first.');
  }
  return Hive.box<TaskModel>('tasks');
});

/// Proveedor para la fuente de datos local de tareas.
final localTaskDatasourceProvider = Provider<LocalTaskDatasource>((ref) {
  final box = ref.watch(hiveBoxProvider);
  return LocalTaskDatasourceImpl(box);
});

/// Proveedor para la fuente de datos LLM.
final llmDatasourceProvider = Provider<LLMDatasource>((ref) {
  return LLMDatasourceImpl();
});

/// Proveedor para el repositorio de tareas.
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final localDatasource = ref.watch(localTaskDatasourceProvider);
  return TaskRepositoryImpl(localDatasource);
});

/// Proveedor para el repositorio LLM.
final llmRepositoryProvider = Provider<LLMRepository>((ref) {
  final llmDatasource = ref.watch(llmDatasourceProvider);
  return LLMRepositoryImpl(llmDatasource);
});

/// Proveedor para los casos de uso de tareas.
final taskUsecasesProvider = Provider<TaskUsecases>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskUsecases(repository);
});

/// Proveedor para los casos de uso LLM.
final llmUsecasesProvider = Provider<LLMUsecases>((ref) {
  final repository = ref.watch(llmRepositoryProvider);
  return LLMUsecases(repository);
});

/// Configura las dependencias necesarias para la aplicación.
///
/// Debe ser llamado antes de usar los providers.
Future<void> setupDependencies() async {
  try {
    if (!Hive.isBoxOpen('tasks')) {
      await Hive.openBox<TaskModel>('tasks');
    }
  } catch (e) {
    rethrow;
  }
}
