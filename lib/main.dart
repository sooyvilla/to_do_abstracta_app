import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/presentation/app.dart';

/// Punto de entrada principal de la aplicación Todo Abstracta.
///
/// Inicializa Flutter, configura Hive como base de datos local,
/// registra los adaptadores necesarios y ejecuta la aplicación
/// con el proveedor de estado Riverpod.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskPriorityAdapter());
    }
    await Hive.openBox<TaskModel>('tasks');

    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error initializing app: $e'),
          ),
        ),
      ),
    );
  }
}
