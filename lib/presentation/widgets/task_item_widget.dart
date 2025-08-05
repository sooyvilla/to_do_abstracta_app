import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_abstracta_app/core/di/injection.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';
import 'package:to_do_abstracta_app/presentation/pages/task_detail_page.dart';
import 'package:to_do_abstracta_app/presentation/widgets/platform_chips.dart';
import 'package:to_do_abstracta_app/presentation/widgets/platform_factory.dart';
import 'package:to_do_abstracta_app/presentation/widgets/platform_navigation.dart';
import 'package:to_do_abstracta_app/presentation/widgets/platform_task_handler.dart';

/// Widget que representa un elemento individual de tarea en la lista.
///
/// Muestra la información de una tarea incluyendo título, descripción,
/// etiquetas, prioridad y estado. Permite marcar como completada,
/// navegar a detalles y acceder a opciones de edición/eliminación.
class TaskItemWidget extends ConsumerWidget {
  /// La tarea a mostrar.
  final Task task;

  /// El índice de la tarea en la lista (usado para animaciones).
  final int index;

  const TaskItemWidget({
    super.key,
    required this.task,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          PlatformNavigation.push(
            context,
            TaskDetailPage(initialTask: task),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      ref.read(taskUsecasesProvider).toggleTaskStatus(task.id);
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted
                                ? theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6)
                                : null,
                          ),
                        ),
                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: task.isCompleted
                                  ? theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6)
                                  : theme.colorScheme.onSurface
                                      .withValues(alpha: 0.8),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  PlatformPriorityIndicator(priority: task.priority),
                  PlatformFactory.createCardMenu(
                    onEdit: () {
                      PlatformTaskHandler.editTask(context, task);
                    },
                    onDelete: () async {
                      final confirmed = await _showDeleteConfirmation(context);
                      if (confirmed) {
                        ref.read(taskUsecasesProvider).deleteTask(task.id);
                      }
                    },
                  ),
                ],
              ),
              if (task.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                PlatformChipList(
                  items: task.tags,
                  scrollable: true,
                  direction: Axis.horizontal,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  PlatformChip.status(task.status),
                  const Spacer(),
                  if (task.assignedUser.isNotEmpty) ...[
                    Icon(
                      Icons.person,
                      size: 16,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task.assignedUser,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmar Eliminación'),
            content: Text(
                '¿Estás seguro de que quieres eliminar la tarea "${task.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Eliminar'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
