import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';
import 'package:to_do_abstracta_app/presentation/providers/task_providers.dart';
import 'package:to_do_abstracta_app/presentation/widgets/task_form_widget.dart';

/// Página para crear o editar tareas.
///
/// Proporciona una interfaz para crear nuevas tareas o editar existentes.
/// Incluye validación de formulario, guardado automático y manejo de estados
/// de carga. Si se proporciona una tarea, entra en modo edición.
class TaskFormPage extends ConsumerWidget {
  /// La tarea a editar. Si es null, se crea una nueva tarea.
  final Task? task;

  const TaskFormPage({super.key, this.task});

  @override
  Widget build(BuildContext context, ref) {
    final formState = ref.watch(taskFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? 'Nueva Tarea' : 'Editar Tarea'),
        actions: [
          if (formState.isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              child: const Text('Guardar'),
              onPressed: () async {
                final success = await ref
                    .read(taskFormProvider.notifier)
                    .saveTask(taskId: task?.id);
                if (success && context.mounted) {
                  ref.read(taskFormProvider.notifier).reset();
                  Navigator.pop(context);
                }
              },
            ),
        ],
      ),
      body: TaskFormWidget(task: task),
    );
  }
}
