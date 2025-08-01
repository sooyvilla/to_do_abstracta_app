import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:to_do_abstracta_app/core/di/injection.dart';
import 'package:to_do_abstracta_app/core/extensions/task_extensions.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';
import 'package:to_do_abstracta_app/presentation/pages/task_form_page.dart';
import 'package:to_do_abstracta_app/presentation/providers/task_providers.dart';

/// Página de detalles de una tarea específica.
///
/// Muestra toda la información de una tarea incluyendo título,
/// descripción, etiquetas, estado, prioridad, fechas y usuario asignado.
/// Proporciona opciones para editar, eliminar y cambiar el estado de la tarea.
class TaskDetailPage extends ConsumerWidget {
  /// La tarea inicial a mostrar.
  final Task initialTask;

  const TaskDetailPage({
    super.key,
    required this.initialTask,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final taskAsync = ref.watch(taskByIdProvider(initialTask.id));

    return taskAsync.when(
      data: (task) {
        if (task == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              Navigator.pop(context);
            }
          });
          return const Scaffold(
            body: Center(child: Text('Tarea no encontrada')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalles de Tarea'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskFormPage(task: task),
                    ),
                  );
                },
              ),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  switch (value) {
                    case 'delete':
                      final confirmed =
                          await _showDeleteConfirmation(context, task);
                      if (confirmed && context.mounted) {
                        Navigator.pop(context);
                        await ref
                            .read(taskUsecasesProvider)
                            .deleteTask(task.id);
                      }
                      break;
                    case 'duplicate':
                      final duplicatedTask = task.copyWith(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: '(Copia) ${task.title}',
                        createdAt: DateTime.now(),
                        updatedAt: null,
                        status: TaskStatus.pending,
                      );
                      await ref
                          .read(taskUsecasesProvider)
                          .createTask(duplicatedTask);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tarea duplicada exitosamente'),
                          ),
                        );
                      }
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        Icon(Icons.copy),
                        SizedBox(width: 8),
                        Text('Duplicar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Eliminar', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Checkbox(
                          value: task.isCompleted,
                          onChanged: (value) {
                            ref
                                .read(taskUsecasesProvider)
                                .toggleTaskStatus(task.id);
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: task.isCompleted
                                      ? theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6)
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _buildStatusChip(task.status, theme),
                                  const SizedBox(width: 8),
                                  _buildPriorityChip(task.priority, theme),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (task.description.isNotEmpty) ...[
                  _buildSection(
                    context,
                    'Descripción',
                    Icons.description,
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          task.description,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                ],
                if (task.tags.isNotEmpty) ...[
                  _buildSection(
                    context,
                    'Etiquetas',
                    Icons.label,
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: task.tags
                              .map((tag) => _buildTag(tag, theme))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
                if (task.assignedUser.isNotEmpty) ...[
                  _buildSection(
                    context,
                    'Usuario Asignado',
                    Icons.person,
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            task.assignedUser.isNotEmpty
                                ? task.assignedUser[0].toUpperCase()
                                : '?',
                          ),
                        ),
                        title: Text(task.assignedUser),
                        subtitle: const Text('Responsable de la tarea'),
                      ),
                    ),
                  ),
                ],
                _buildSection(
                  context,
                  'Información de Fechas',
                  Icons.schedule,
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.add_circle_outline),
                          title: const Text('Fecha de Creación'),
                          subtitle: Text(_formatDate(task.createdAt)),
                        ),
                        if (task.updatedAt != null) ...[
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.update),
                            title: const Text('Última Actualización'),
                            subtitle: Text(_formatDate(task.updatedAt!)),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                _buildSection(
                  context,
                  'Estadísticas',
                  Icons.analytics,
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                context,
                                'Días Creada',
                                DateTime.now()
                                    .difference(task.createdAt)
                                    .inDays
                                    .toString(),
                                Icons.calendar_today,
                              ),
                              _buildStatItem(
                                context,
                                'Etiquetas',
                                task.tags.length.toString(),
                                Icons.label,
                              ),
                              _buildStatItem(
                                context,
                                'Caracteres',
                                task.description.length.toString(),
                                Icons.text_fields,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          title: const Text('Detalles de Tarea'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          title: const Text('Detalles de Tarea'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error cargando tarea',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, IconData icon, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildTag(String tag, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        tag,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatusChip(TaskStatus status, ThemeData theme) {
    Color color = status.color;
    String label = status.label;
    IconData icon = status.icon;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(TaskPriority priority, ThemeData theme) {
    Color color = priority.color;
    String label = priority.label;
    IconData icon = priority.icon;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  Future<bool> _showDeleteConfirmation(BuildContext context, Task task) async {
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
