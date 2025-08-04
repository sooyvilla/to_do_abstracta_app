import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_abstracta_app/core/extensions/task_extensions.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';

class PlatformDropdown<T> extends StatelessWidget {
  final T? value;
  final List<PlatformDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final InputDecoration? decoration;

  const PlatformDropdown({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.hint,
    this.decoration,
  });

  /// Factory method para crear un dropdown básico
  factory PlatformDropdown.basic({
    required List<PlatformDropdownItem<T>> items,
    T? value,
    ValueChanged<T?>? onChanged,
    String? hint,
  }) {
    return PlatformDropdown<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      hint: hint,
    );
  }

  /// Factory method para crear un dropdown con decoración
  factory PlatformDropdown.withDecoration({
    required List<PlatformDropdownItem<T>> items,
    required String labelText,
    T? value,
    ValueChanged<T?>? onChanged,
    String? hint,
  }) {
    return PlatformDropdown<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      hint: hint,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  /// Factory method específico para estados de tarea
  factory PlatformDropdown.taskStatus({
    TaskStatus? value,
    ValueChanged<TaskStatus?>? onChanged,
    String? hint,
  }) {
    final items = TaskStatus.values.map((status) {
      return PlatformDropdownItem<TaskStatus>(
        value: status,
        title: status.label,
        child: Text(status.label),
      );
    }).toList();

    return PlatformDropdown<TaskStatus>(
      value: value,
      items: items,
      onChanged: onChanged,
      hint: hint ?? 'Estado',
      decoration: const InputDecoration(
        labelText: 'Estado',
        border: OutlineInputBorder(),
      ),
    ) as PlatformDropdown<T>;
  }

  /// Factory method específico para prioridades de tarea
  factory PlatformDropdown.taskPriority({
    TaskPriority? value,
    ValueChanged<TaskPriority?>? onChanged,
    String? hint,
  }) {
    final items = TaskPriority.values.map((priority) {
      return PlatformDropdownItem<TaskPriority>(
        value: priority,
        title: priority.label,
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: priority.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(priority.label),
          ],
        ),
      );
    }).toList();

    return PlatformDropdown<TaskPriority>(
      value: value,
      items: items,
      onChanged: onChanged,
      hint: hint ?? 'Prioridad',
      decoration: const InputDecoration(
        labelText: 'Prioridad',
        border: OutlineInputBorder(),
      ),
    ) as PlatformDropdown<T>;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoDropdown(context);
    } else {
      return _buildMaterialDropdown(context);
    }
  }

  Widget _buildMaterialDropdown(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: decoration ??
          const InputDecoration(
            border: OutlineInputBorder(),
          ),
      hint: hint != null ? Text(hint!) : null,
      items: items
          .map((item) => DropdownMenuItem<T>(
                value: item.value,
                child: item.child,
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildCupertinoDropdown(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoColors.systemGrey4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        onPressed:
            onChanged != null ? () => _showCupertinoPicker(context) : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value != null
                  ? items.firstWhere((item) => item.value == value).title
                  : hint ?? 'Seleccionar',
              style: TextStyle(
                color: value != null
                    ? CupertinoColors.label
                    : CupertinoColors.placeholderText,
              ),
            ),
            const Icon(CupertinoIcons.chevron_down, size: 16),
          ],
        ),
      ),
    );
  }

  void _showCupertinoPicker(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => Container(
        height: 250,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text('Cancelar'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoButton(
                      child: const Text('Listo'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: 32,
                  scrollController: FixedExtentScrollController(
                    initialItem: value != null
                        ? items.indexWhere((item) => item.value == value)
                        : 0,
                  ),
                  onSelectedItemChanged: (int selectedItem) {
                    onChanged?.call(items[selectedItem].value);
                  },
                  children:
                      items.map((item) => Center(child: item.child)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlatformDropdownItem<T> {
  final T value;
  final Widget child;
  final String title;

  const PlatformDropdownItem({
    required this.value,
    required this.child,
    required this.title,
  });
}
