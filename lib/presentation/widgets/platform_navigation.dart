import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Utilidades de navegación adaptables a la plataforma.
///
/// Proporciona métodos para navegar de manera nativa en cada plataforma:
/// - Android: Navegación de pantalla completa
/// - iOS: Modales deslizantes desde abajo
class PlatformNavigation {
  PlatformNavigation._();

  /// Factory method para navegación básica
  static Future<T?> pushPage<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return push<T>(context, page);
  }

  /// Factory method para navegación modal
  static Future<T?> pushModal<T extends Object?>(
    BuildContext context,
    Widget page, {
    String? title,
  }) {
    return push<T>(
      context,
      page,
      title: title,
      fullscreenDialog: true,
    );
  }

  /// Factory method para mostrar formularios
  static Future<T?> showForm<T extends Object?>(
    BuildContext context,
    Widget content, {
    required String title,
  }) {
    return showModal<T>(
      context,
      content,
      title: title,
      isDismissible: true,
    );
  }

  /// Factory method para mostrar confirmaciones
  static Future<bool?> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    bool isDestructive = false,
  }) {
    return showAlert<bool>(
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
          isDestructive: isDestructive,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }

  /// Navega a una nueva página de forma adaptable a la plataforma.
  ///
  /// En Android usa [MaterialPageRoute] para navegación de pantalla completa.
  /// En iOS usa [CupertinoPageRoute] para navegación con transición nativa.
  static Future<T?> push<T extends Object?>(
    BuildContext context,
    Widget page, {
    String? title,
    bool fullscreenDialog = false,
  }) {
    if (Platform.isIOS) {
      return Navigator.push<T>(
        context,
        CupertinoPageRoute<T>(
          builder: (context) => page,
          title: title,
          fullscreenDialog: fullscreenDialog,
        ),
      );
    } else {
      return Navigator.push<T>(
        context,
        MaterialPageRoute<T>(
          builder: (context) => page,
          fullscreenDialog: fullscreenDialog,
        ),
      );
    }
  }

  /// Muestra un modal desde la parte inferior (iOS) o dialog (Android).
  ///
  /// En iOS usa [showCupertinoModalPopup] con diseño nativo.
  /// En Android usa [showModalBottomSheet] con Material Design.
  static Future<T?> showModal<T extends Object?>(
    BuildContext context,
    Widget content, {
    String? title,
    bool isDismissible = true,
    bool useRootNavigator = true,
    bool enableDrag = true,
  }) {
    if (Platform.isIOS) {
      return showCupertinoModalPopup<T>(
        context: context,
        useRootNavigator: useRootNavigator,
        builder: (context) => Container(
          decoration: const BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          height: MediaQuery.of(context).size.height * 0.9,
          child: content,
        ),
      );
    } else {
      return showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        useRootNavigator: useRootNavigator,
        useSafeArea: true,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) => Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                if (title != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: content,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  /// Muestra un diálogo adaptable a la plataforma.
  ///
  /// En iOS usa [CupertinoAlertDialog].
  /// En Android usa [AlertDialog].
  static Future<T?> showAlert<T extends Object?>(
    BuildContext context, {
    required String title,
    String? content,
    required List<PlatformAlertAction> actions,
  }) {
    if (Platform.isIOS) {
      return showCupertinoDialog<T>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: content != null ? Text(content) : null,
          actions: actions
              .map((action) => CupertinoDialogAction(
                    onPressed: action.onPressed,
                    isDestructiveAction: action.isDestructive,
                    isDefaultAction: action.isDefault,
                    child: Text(action.text),
                  ))
              .toList(),
        ),
      );
    } else {
      return showDialog<T>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: content != null ? Text(content) : null,
          actions: actions
              .map((action) => TextButton(
                    onPressed: action.onPressed,
                    child: Text(
                      action.text,
                      style: TextStyle(
                        color: action.isDestructive ? Colors.red : null,
                      ),
                    ),
                  ))
              .toList(),
        ),
      );
    }
  }

  /// Muestra un ActionSheet adaptable a la plataforma.
  ///
  /// En iOS usa [CupertinoActionSheet].
  /// En Android usa [showModalBottomSheet] con lista de opciones.
  static Future<T?> showActionSheet<T extends Object?>(
    BuildContext context, {
    String? title,
    String? message,
    required List<PlatformSheetAction> actions,
    PlatformSheetAction? cancelAction,
  }) {
    if (Platform.isIOS) {
      return showCupertinoModalPopup<T>(
        context: context,
        builder: (context) => CupertinoActionSheet(
          title: title != null ? Text(title) : null,
          message: message != null ? Text(message) : null,
          actions: actions
              .map((action) => CupertinoActionSheetAction(
                    onPressed:
                        action.onPressed ?? () => Navigator.of(context).pop(),
                    isDestructiveAction: action.isDestructive,
                    child: Text(action.text),
                  ))
              .toList(),
          cancelButton: cancelAction != null
              ? CupertinoActionSheetAction(
                  onPressed: cancelAction.onPressed ??
                      () => Navigator.of(context).pop(),
                  child: Text(cancelAction.text),
                )
              : null,
        ),
      );
    } else {
      return showModalBottomSheet<T>(
        context: context,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null || message != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (title != null)
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    if (message != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ...actions.map((action) => ListTile(
                  title: Text(
                    action.text,
                    style: TextStyle(
                      color: action.isDestructive ? Colors.red : null,
                    ),
                  ),
                  onTap: action.onPressed ?? () => Navigator.of(context).pop(),
                )),
            if (cancelAction != null)
              ListTile(
                title: Text(cancelAction.text),
                onTap:
                    cancelAction.onPressed ?? () => Navigator.of(context).pop(),
              ),
            const SizedBox(height: 16),
          ],
        ),
      );
    }
  }
}

/// Representa una acción en un diálogo de alerta.
class PlatformAlertAction {
  final String text;
  final VoidCallback? onPressed;
  final bool isDestructive;
  final bool isDefault;

  const PlatformAlertAction({
    required this.text,
    this.onPressed,
    this.isDestructive = false,
    this.isDefault = false,
  });
}

/// Representa una acción en un ActionSheet.
class PlatformSheetAction {
  final String text;
  final VoidCallback? onPressed;
  final bool isDestructive;

  const PlatformSheetAction({
    required this.text,
    this.onPressed,
    this.isDestructive = false,
  });
}
