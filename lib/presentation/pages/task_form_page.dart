import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';
import 'package:to_do_abstracta_app/presentation/providers/task_providers.dart';
import 'package:to_do_abstracta_app/presentation/widgets/platform_factory.dart';
import 'package:to_do_abstracta_app/presentation/widgets/task_form_widget.dart';

/// Página para crear o editar tareas.
class TaskFormPage extends ConsumerWidget {
  final Task? task;

  const TaskFormPage({super.key, this.task});

  @override
  Widget build(BuildContext context, ref) {
    final formState = ref.watch(taskFormProvider);

    return PlatformFactory.createScaffold(
      appBar: PlatformFactory.createAppBar(
        title: task == null ? 'Nueva Tarea' : 'Editar Tarea',
        actions: [
          if (formState.isLoading)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PlatformFactory.createLoadingIndicator(),
            )
          else
            PlatformFactory.createButton(
              text: 'Guardar',
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
