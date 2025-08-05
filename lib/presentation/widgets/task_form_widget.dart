import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_abstracta_app/core/extensions/task_extensions.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/domain/entities/task.dart';
import 'package:to_do_abstracta_app/presentation/providers/task_providers.dart';
import 'package:to_do_abstracta_app/presentation/widgets/platform_dropdown.dart';
import 'package:to_do_abstracta_app/presentation/widgets/platform_widgets.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final _assignedUserController = TextEditingController();

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(taskFormProvider.notifier).loadTask(widget.task!);
        _initializeControllers();
      });
    }
  }

  void _initializeControllers() {
    if (!_isInitialized && widget.task != null) {
      final task = widget.task!;
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _tagsController.text = task.tags.join(', ');
      _assignedUserController.text = task.assignedUser;
      _isInitialized = true;
    }
  }

  void _syncControllersWithState(TaskFormState state) {
    if (!_isInitialized) {
      _descriptionController.text = state.description;
      _tagsController.text = state.tags.join(', ');
      _assignedUserController.text = state.assignedUser;
    }
  }

  bool validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  TaskFormState getFormData() {
    return ref.read(taskFormProvider);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _assignedUserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(taskFormProvider);
    final formNotifier = ref.read(taskFormProvider.notifier);

    _syncControllersWithState(formState);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
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
            _buildPlatformTextField(
              controller: _titleController,
              labelText: 'Título *',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El título es requerido';
                }
                return null;
              },
              onChanged: formNotifier.updateTitle,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: PlatformButton.primary(
                    text: formState.isGeneratingDescription
                        ? 'Generando...'
                        : 'Autocompletar con IA',
                    icon: Icons.auto_fix_high,
                    isLoading: formState.isGeneratingDescription,
                    onPressed: formState.isGeneratingDescription
                        ? () {}
                        : () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              final title = _titleController.text.trim();
                              if (title.isNotEmpty) {
                                await formNotifier
                                    .generateCompleteTaskFromTitle(title);
                              }
                            }
                          },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPlatformTextField(
              controller: _descriptionController,
              labelText: 'Descripción',
              hintText: 'Describe la tarea...',
              maxLines: 4,
              onChanged: formNotifier.updateDescription,
            ),
            const SizedBox(height: 16),
            _buildPlatformTextField(
              controller: _tagsController,
              labelText: 'Etiquetas (separadas por comas)',
              hintText: 'ej. trabajo, urgente, reunión',
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
            _buildPlatformTextField(
              controller: _assignedUserController,
              labelText: 'Usuario Asignado',
              hintText: 'Ingresa el usuario asignado',
              onChanged: formNotifier.updateAssignedUser,
            ),
            const SizedBox(height: 16),
            PlatformDropdown<TaskStatus>(
              value: formState.status,
              hint: 'Estado',
              decoration: const InputDecoration(
                labelText: 'Estado',
                border: OutlineInputBorder(),
              ),
              items: TaskStatus.values.map((status) {
                return PlatformDropdownItem(
                  value: status,
                  title: status.label,
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
            PlatformDropdown<TaskPriority>(
              value: formState.priority,
              hint: 'Prioridad',
              decoration: const InputDecoration(
                labelText: 'Prioridad',
                border: OutlineInputBorder(),
              ),
              items: TaskPriority.values.map((priority) {
                return PlatformDropdownItem(
                  value: priority,
                  title: priority.label,
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

  Widget _buildPlatformTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    int maxLines = 1,
  }) {
    if (Platform.isIOS) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          CupertinoTextField(
            controller: controller,
            placeholder: hintText ?? labelText.replaceAll(' *', ''),
            maxLines: maxLines,
            decoration: BoxDecoration(
              border: Border.all(
                color: CupertinoColors.systemGrey4,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            onChanged: onChanged,
          ),
        ],
      );
    } else {
      return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
        onChanged: onChanged,
        maxLines: maxLines,
      );
    }
  }
}
