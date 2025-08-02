import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_abstracta_app/core/di/injection.dart';
import 'package:to_do_abstracta_app/core/extensions/task_extensions.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';
import 'package:to_do_abstracta_app/presentation/pages/task_detail_page.dart';
import 'package:to_do_abstracta_app/presentation/pages/task_form_page.dart';

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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailPage(initialTask: task),
            ),
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
                  _buildPriorityIndicator(task.priority, theme),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      switch (value) {
                        case 'edit':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskFormPage(task: task),
                            ),
                          );
                          break;
                        case 'delete':
                          await ref
                              .read(taskUsecasesProvider)
                              .deleteTask(task.id);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Eliminar',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (task.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children:
                      task.tags.map((tag) => _buildTag(tag, theme)).toList(),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildStatusChip(task.status, theme),
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

  Widget _buildTag(String tag, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tag,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _buildStatusChip(TaskStatus status, ThemeData theme) {
    Color color = status.color;
    String label = status.label;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(TaskPriority priority, ThemeData theme) {
    Color color = priority.color;

    return Container(
      width: 4,
      height: 40,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
