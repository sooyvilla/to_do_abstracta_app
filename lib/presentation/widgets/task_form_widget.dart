import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_abstracta_app/core/extensions/task_extensions.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';
import 'package:to_do_abstracta_app/presentation/providers/task_providers.dart';

/// Widget de formulario para crear y editar tareas.
///
/// Proporciona campos para todos los atributos de una tarea incluyendo
/// título, descripción, etiquetas, usuario asignado, estado y prioridad.
/// Incluye funcionalidad de IA para generar descripciones automáticamente.
class TaskFormWidget extends ConsumerStatefulWidget {
  /// La tarea a editar. Si es null, se crea una nueva tarea.
  final Task? task;

  const TaskFormWidget({super.key, this.task});

  @override
  ConsumerState<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends ConsumerState<TaskFormWidget> {
  final textIaController = TextEditingController();
  final descriptionController = TextEditingController();
  final titleController = TextEditingController();
  final tagsController = TextEditingController();
  final assignedUserController = TextEditingController();
  final statusController = TextEditingController();
  final priorityController = TextEditingController();
  TaskStatus? valueStatus;
  TaskPriority? valuePriority;

  @override
  void initState() {
    if (widget.task != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(taskFormProvider.notifier).loadTask(widget.task!);
      });

      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      tagsController.text = widget.task!.tags.join(', ');
      assignedUserController.text = widget.task!.assignedUser;
      statusController.text = widget.task!.status.label;
      priorityController.text = widget.task!.priority.label;
      valueStatus = widget.task!.status;
      valuePriority = widget.task!.priority;
    }
    super.initState();
  }

  @override
  void dispose() {
    textIaController.dispose();
    descriptionController.dispose();
    titleController.dispose();
    tagsController.dispose();
    assignedUserController.dispose();
    statusController.dispose();
    priorityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(taskFormProvider);
    final formNotifier = ref.read(taskFormProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (formState.error != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Text(
                formState.error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 16),
          ],
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Título *',
              border: OutlineInputBorder(),
            ),
            onChanged: formNotifier.updateTitle,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome),
                      const SizedBox(width: 8),
                      Text(
                        'Generador de Descripción IA',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ingresa un prompt y deja que la IA genere una descripción detallada para tu tarea.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: textIaController,
                          decoration: const InputDecoration(
                            hintText:
                                'ej. "Planificar reunión semanal del equipo"',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final prompt = textIaController.text.trim();
                          final res =
                              await formNotifier.generateDescription(prompt);
                          if (res != null) {
                            descriptionController.text = res;
                            formNotifier.updateDescription(res);
                            textIaController.clear();
                          }
                        },
                        child: formState.isGeneratingDescription
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Generar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            onChanged: formNotifier.updateDescription,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: tagsController,
            decoration: const InputDecoration(
              labelText: 'Etiquetas (separadas por comas)',
              border: OutlineInputBorder(),
              helperText: 'ej. trabajo, urgente, reunión',
            ),
            onChanged: (value) {
              final tags = value
                  .split(',')
                  .map((tag) => tag.trim())
                  .where((tag) => tag.isNotEmpty)
                  .toList();
              formNotifier.updateTags(tags);
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: assignedUserController,
            decoration: const InputDecoration(
              labelText: 'Usuario Asignado',
              border: OutlineInputBorder(),
            ),
            onChanged: formNotifier.updateAssignedUser,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<TaskStatus>(
            value: valueStatus,
            decoration: const InputDecoration(
              labelText: 'Estado',
              border: OutlineInputBorder(),
            ),
            items: TaskStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status.label),
              );
            }).toList(),
            onChanged: (status) {
              if (status != null) {
                formNotifier.updateStatus(status);
              }
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<TaskPriority>(
            value: valuePriority,
            decoration: const InputDecoration(
              labelText: 'Prioridad',
              border: OutlineInputBorder(),
            ),
            items: TaskPriority.values.map((priority) {
              return DropdownMenuItem(
                value: priority,
                child: Row(
                  children: [
                    _buildPriorityIndicator(priority),
                    const SizedBox(width: 8),
                    Text(priority.label),
                  ],
                ),
              );
            }).toList(),
            onChanged: (priority) {
              if (priority != null) {
                formNotifier.updatePriority(priority);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityIndicator(TaskPriority priority) {
    Color color = priority.color;

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
