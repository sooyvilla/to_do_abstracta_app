import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_abstracta_app/core/extensions/task_extensions.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';

/// Chip adaptable a la plataforma para mostrar estados, prioridades y etiquetas.
class PlatformChip extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final PlatformChipStyle style;

  const PlatformChip({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    this.icon,
    this.onTap,
    this.onDelete,
    this.style = PlatformChipStyle.filled,
  });

  /// Constructor específico para estado de tarea
  factory PlatformChip.status(
    TaskStatus status, {
    VoidCallback? onTap,
  }) {
    return PlatformChip(
      text: status.label,
      color: status.color,
      icon: status.icon,
      onTap: onTap,
      style: PlatformChipStyle.outlined,
    );
  }

  /// Constructor específico para prioridad de tarea
  factory PlatformChip.priority(
    TaskPriority priority, {
    VoidCallback? onTap,
  }) {
    return PlatformChip(
      text: priority.label,
      color: priority.color,
      icon: priority.icon,
      onTap: onTap,
      style: PlatformChipStyle.filled,
    );
  }

  /// Constructor específico para etiquetas
  factory PlatformChip.tag(
    String tag, {
    VoidCallback? onTap,
    VoidCallback? onDelete,
  }) {
    return PlatformChip(
      text: tag,
      onTap: onTap,
      onDelete: onDelete,
      style: PlatformChipStyle.outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoChip(context);
    } else {
      return _buildMaterialChip(context);
    }
  }

  Widget _buildCupertinoChip(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final chipColor = color ?? theme.primaryColor;
    final backgroundColor = style == PlatformChipStyle.filled
        ? chipColor.withValues(alpha: 0.1)
        : CupertinoColors.systemBackground;
    final borderColor = chipColor.withValues(alpha: 0.3);
    final finalTextColor = textColor ??
        (style == PlatformChipStyle.filled ? chipColor : CupertinoColors.label);

    Widget child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: finalTextColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: finalTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                CupertinoIcons.xmark_circle_fill,
                size: 16,
                color: finalTextColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      child = CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        onPressed: onTap,
        child: child,
      );
    }

    return child;
  }

  Widget _buildMaterialChip(BuildContext context) {
    final theme = Theme.of(context);
    final chipColor = color ?? theme.colorScheme.primary;
    final backgroundColor = style == PlatformChipStyle.filled
        ? chipColor.withValues(alpha: 0.1)
        : theme.colorScheme.surface;
    final borderColor = chipColor.withValues(alpha: 0.3);
    final finalTextColor = textColor ??
        (style == PlatformChipStyle.filled
            ? chipColor
            : theme.colorScheme.onSurface);

    Widget child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: finalTextColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: finalTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.close,
                size: 16,
                color: finalTextColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      child = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: child,
      );
    }

    return child;
  }
}

enum PlatformChipStyle {
  filled,
  outlined,
}

/// Indicador de prioridad adaptable
class PlatformPriorityIndicator extends StatelessWidget {
  final TaskPriority priority;
  final double? width;
  final double? height;

  const PlatformPriorityIndicator({
    super.key,
    required this.priority,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final color = priority.color;

    return Container(
      width: width ?? 4,
      height: height ?? 40,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

/// Lista de chips adaptable
class PlatformChipList extends StatelessWidget {
  final List<String> items;
  final Function(String)? onItemTap;
  final Function(String)? onItemDelete;
  final Color? chipColor;
  final bool scrollable;
  final Axis direction;

  const PlatformChipList({
    super.key,
    required this.items,
    this.onItemTap,
    this.onItemDelete,
    this.chipColor,
    this.scrollable = false,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    final chips = items
        .map((item) => PlatformChip.tag(
              item,
              onTap: onItemTap != null ? () => onItemTap!(item) : null,
              onDelete: onItemDelete != null ? () => onItemDelete!(item) : null,
            ))
        .toList();

    if (scrollable) {
      return SingleChildScrollView(
        scrollDirection: direction,
        child: direction == Axis.horizontal
            ? Row(
                children: chips
                    .map((chip) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: chip,
                        ))
                    .toList(),
              )
            : Column(
                children: chips
                    .map((chip) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: chip,
                        ))
                    .toList(),
              ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips,
    );
  }
}
