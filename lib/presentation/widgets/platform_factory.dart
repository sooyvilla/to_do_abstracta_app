import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Factory class para crear widgets específicos de plataforma (iOS/Android)
class PlatformFactory {
  static bool get isIOS => Platform.isIOS;
  static bool get isAndroid => Platform.isAndroid;

  static Widget createText(String text, {TextStyle? style}) {
    return Text(text, style: style);
  }

  static Widget createButton({
    required String text,
    required VoidCallback onPressed,
    bool isPrimary = true,
  }) {
    if (isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        color: isPrimary ? CupertinoColors.activeBlue : null,
        child: Text(text),
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: isPrimary
            ? null
            : ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black87,
              ),
        child: Text(text),
      );
    }
  }

  static Widget createTextField({
    String? placeholder,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    bool obscureText = false,
    int? maxLines,
  }) {
    if (isIOS) {
      return CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        onChanged: onChanged,
        obscureText: obscureText,
        maxLines: maxLines,
        padding: const EdgeInsets.all(12),
      );
    } else {
      return TextField(
        controller: controller,
        onChanged: onChanged,
        obscureText: obscureText,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: placeholder,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(12),
        ),
      );
    }
  }

  static Widget createSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    if (isIOS) {
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
      );
    } else {
      return Switch(
        value: value,
        onChanged: onChanged,
      );
    }
  }

  static Widget createListTile({
    Widget? leading,
    required Widget title,
    Widget? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    if (isIOS) {
      return CupertinoListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
      );
    } else {
      return ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
      );
    }
  }

  static PreferredSizeWidget createAppBar({
    required String title,
    List<Widget>? actions,
    Widget? leading,
  }) {
    if (isIOS) {
      return CupertinoNavigationBar(
        middle: Text(title),
        trailing: actions != null && actions.isNotEmpty
            ? Row(mainAxisSize: MainAxisSize.min, children: actions)
            : null,
        leading: leading,
      ) as PreferredSizeWidget;
    } else {
      return AppBar(
        title: Text(title),
        actions: actions,
        leading: leading,
      );
    }
  }

  static Widget createScaffold({
    PreferredSizeWidget? appBar,
    required Widget body,
    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
    Widget? searchBar,
  }) {
    if (isIOS) {
      return CupertinoPageScaffold(
        navigationBar: appBar as CupertinoNavigationBar?,
        child: SafeArea(
          child: Column(
            children: [
              if (searchBar != null) searchBar,
              Expanded(
                child: Stack(
                  children: [
                    body,
                    if (floatingActionButton != null)
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: floatingActionButton,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            if (searchBar != null) searchBar,
            Expanded(child: body),
          ],
        ),
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      );
    }
  }

  static Widget createAlertDialog({
    required String title,
    required String content,
    required List<Widget> actions,
  }) {
    if (isIOS) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions,
      );
    } else {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions,
      );
    }
  }

  static Widget createCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    if (isIOS) {
      return Transform.scale(
        scale: 1.2,
        child: Checkbox(
          value: value,
          onChanged: onChanged,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    } else {
      return Checkbox(
        value: value,
        onChanged: onChanged,
      );
    }
  }

  static Widget createIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    if (isIOS) {
      return CupertinoButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        child: Icon(icon, color: color ?? CupertinoColors.activeBlue),
      );
    } else {
      return IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: color,
      );
    }
  }

  static Widget createLoadingIndicator() {
    if (isIOS) {
      return const CupertinoActivityIndicator();
    } else {
      return const CircularProgressIndicator();
    }
  }

  static Widget createSlider({
    required double value,
    required ValueChanged<double> onChanged,
    double min = 0.0,
    double max = 1.0,
  }) {
    if (isIOS) {
      return CupertinoSlider(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
      );
    } else {
      return Slider(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
      );
    }
  }

  static Widget createCardMenu({
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    IconData triggerIcon = Icons.more_vert,
  }) {
    if (Platform.isIOS) {
      return _IOSCardMenu(
        onEdit: onEdit,
        onDelete: onDelete,
        triggerIcon: triggerIcon,
      );
    } else {
      return _AndroidCardMenu(
        onEdit: onEdit,
        onDelete: onDelete,
        triggerIcon: triggerIcon,
      );
    }
  }

  static Widget createDetailsMenu({
    required VoidCallback onEdit,
    required VoidCallback onDuplicate,
    required VoidCallback onDelete,
    IconData triggerIcon = Icons.more_vert,
  }) {
    if (Platform.isIOS) {
      return _IOSDetailsMenu(
        onEdit: onEdit,
        onDuplicate: onDuplicate,
        onDelete: onDelete,
        triggerIcon: triggerIcon,
      );
    } else {
      return _AndroidDetailsMenu(
        onEdit: onEdit,
        onDuplicate: onDuplicate,
        onDelete: onDelete,
        triggerIcon: triggerIcon,
      );
    }
  }
}

class _IOSCardMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final IconData triggerIcon;

  const _IOSCardMenu({
    required this.onEdit,
    required this.onDelete,
    required this.triggerIcon,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () => _showActionSheet(context),
      padding: EdgeInsets.zero,
      child: Icon(
        triggerIcon,
        color: CupertinoColors.systemBlue,
      ),
    );
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              onEdit();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8),
                Text('Editar'),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            isDestructiveAction: true,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8),
                Text('Eliminar'),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ),
    );
  }
}

class _AndroidCardMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final IconData triggerIcon;

  const _AndroidCardMenu({
    required this.onEdit,
    required this.onDelete,
    required this.triggerIcon,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              SizedBox(width: 12),
              Text('Editar'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              SizedBox(width: 12),
              Text('Eliminar', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      child: Icon(triggerIcon),
    );
  }
}

class _IOSDetailsMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final IconData triggerIcon;

  const _IOSDetailsMenu({
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    required this.triggerIcon,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () => _showActionSheet(context),
      padding: EdgeInsets.zero,
      child: Icon(
        triggerIcon,
        color: CupertinoColors.systemBlue,
      ),
    );
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              onEdit();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8),
                Text('Editar'),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              onDuplicate();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8),
                Text('Duplicar'),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            isDestructiveAction: true,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8),
                Text('Eliminar'),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ),
    );
  }
}

class _AndroidDetailsMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final IconData triggerIcon;

  const _AndroidDetailsMenu({
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    required this.triggerIcon,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit();
            break;
          case 'duplicate':
            onDuplicate();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              SizedBox(width: 12),
              Text('Editar'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'duplicate',
          child: Row(
            children: [
              SizedBox(width: 12),
              Text('Duplicar'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              SizedBox(width: 12),
              Text('Eliminar', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      child: Icon(triggerIcon),
    );
  }
}
