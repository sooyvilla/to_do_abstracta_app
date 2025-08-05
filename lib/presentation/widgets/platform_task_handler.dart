import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';
import 'package:to_do_abstracta_app/presentation/providers/task_providers.dart';
import 'package:to_do_abstracta_app/presentation/widgets/platform_navigation.dart';
import 'package:to_do_abstracta_app/presentation/widgets/task_form_widget.dart';

/// Manejador adaptable para la creación y edición de tareas.
///
/// En Android navega a una nueva pantalla.
/// En iOS muestra un modal deslizante desde abajo.
class PlatformTaskHandler {
  static Future<void> createTask(BuildContext context) {
    if (Platform.isIOS) {
      return _showIOSTaskModal(context);
    } else {
      return _navigateToAndroidTaskPage(context);
    }
  }

  static Future<void> editTask(BuildContext context, Task task) {
    if (Platform.isIOS) {
      return _showIOSTaskModal(context, task: task);
    } else {
      return _navigateToAndroidTaskPage(context, task: task);
    }
  }

  static Future<void> _showIOSTaskModal(
    BuildContext context, {
    Task? task,
  }) {
    return PlatformNavigation.showModal(
      context,
      _IOSTaskModalContent(task: task),
      title: task == null ? 'Nueva Tarea' : 'Editar Tarea',
    );
  }

  static Future<void> _navigateToAndroidTaskPage(
    BuildContext context, {
    Task? task,
  }) {
    return PlatformNavigation.push(
      context,
      _AndroidTaskPage(task: task),
    );
  }
}

/// Contenido del modal para iOS
class _IOSTaskModalContent extends ConsumerWidget {
  final Task? task;

  const _IOSTaskModalContent({this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(taskFormProvider);

    return Material(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: CupertinoColors.separator,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text('Cancelar'),
                  onPressed: () {
                    ref.read(taskFormProvider.notifier).reset();
                    Navigator.of(context).pop();
                  },
                ),
                Text(
                  task == null ? 'Nueva Tarea' : 'Editar Tarea',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                formState.isLoading
                    ? const CupertinoActivityIndicator()
                    : CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Text('Guardar'),
                        onPressed: () async {
                          final success = await ref
                              .read(taskFormProvider.notifier)
                              .saveTask(taskId: task?.id);
                          if (success && context.mounted) {
                            ref.read(taskFormProvider.notifier).reset();
                            Navigator.of(context).pop();
                          }
                        },
                      ),
              ],
            ),
          ),
          Expanded(
            child: TaskFormWidget(task: task),
          ),
        ],
      ),
    );
  }
}

/// Página completa para Android
class _AndroidTaskPage extends ConsumerWidget {
  final Task? task;

  const _AndroidTaskPage({this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

/// FAB adaptable que muestra diferentes comportamientos por plataforma
class PlatformTaskFAB extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? tooltip;

  const PlatformTaskFAB({
    super.key,
    this.onPressed,
    this.icon,
    this.tooltip,
  });

  /// Factory method para crear un FAB básico para crear tareas
  factory PlatformTaskFAB.create() {
    return PlatformTaskFAB(
      onPressed: () {}, // Se configurará en build()
      icon: Platform.isIOS ? CupertinoIcons.add : Icons.add,
      tooltip: 'Crear nueva tarea',
    );
  }

  /// Factory method para crear un FAB personalizado
  factory PlatformTaskFAB.custom({
    required VoidCallback onPressed,
    IconData? icon,
    String? tooltip,
  }) {
    return PlatformTaskFAB(
      onPressed: onPressed,
      icon: icon ?? (Platform.isIOS ? CupertinoIcons.add : Icons.add),
      tooltip: tooltip,
    );
  }

  @override
  Widget build(BuildContext context) {
    final callback = onPressed ?? () => PlatformTaskHandler.createTask(context);
    final buttonIcon =
        icon ?? (Platform.isIOS ? CupertinoIcons.add : Icons.add);

    if (Platform.isIOS) {
      return CupertinoButton.filled(
        onPressed: callback,
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(30),
        child: Icon(
          buttonIcon,
          color: CupertinoColors.white,
        ),
      );
    } else {
      return FloatingActionButton(
        onPressed: callback,
        tooltip: tooltip,
        child: Icon(buttonIcon),
      );
    }
  }
}

/// Widget de confirmación adaptable para eliminar tareas
class PlatformDeleteConfirmation {
  /// Muestra un diálogo de confirmación básico para eliminar
  static Future<bool> show(
    BuildContext context, {
    required String taskTitle,
  }) {
    return _showDeleteDialog(
      context,
      title: 'Eliminar Tarea',
      message: '¿Estás seguro de que quieres eliminar la tarea "$taskTitle"?',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
    );
  }

  /// Factory method para confirmación de eliminación múltiple
  static Future<bool> showMultiple(
    BuildContext context, {
    required int taskCount,
  }) {
    return _showDeleteDialog(
      context,
      title: 'Eliminar Tareas',
      message:
          '¿Estás seguro de que quieres eliminar $taskCount tareas seleccionadas?',
      confirmText: 'Eliminar Todas',
      cancelText: 'Cancelar',
    );
  }

  /// Factory method para confirmación de eliminación permanente
  static Future<bool> showPermanent(
    BuildContext context, {
    required String taskTitle,
  }) {
    return _showDeleteDialog(
      context,
      title: 'Eliminar Permanentemente',
      message:
          '¿Estás seguro de que quieres eliminar permanentemente la tarea "$taskTitle"? Esta acción no se puede deshacer.',
      confirmText: 'Eliminar Permanentemente',
      cancelText: 'Cancelar',
    );
  }

  static Future<bool> _showDeleteDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
  }) async {
    final result = await PlatformNavigation.showAlert<bool>(
      context,
      title: title,
      content: message,
      actions: [
        PlatformAlertAction(
          text: cancelText,
          isDefault: true,
        ),
        PlatformAlertAction(
          text: confirmText,
          isDestructive: true,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );

    return result ?? false;
  }
}
