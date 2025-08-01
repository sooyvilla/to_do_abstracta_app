import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

/// Botón de acción flotante adaptable a la plataforma.
///
/// Muestra un FloatingActionButton en Android y Material Design,
/// y un CupertinoButton.filled en iOS, proporcionando una experiencia
/// nativa en cada plataforma.
class PlatformFAB extends StatelessWidget {
  /// Callback ejecutado cuando se presiona el botón.
  final VoidCallback onPressed;

  const PlatformFAB({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      material: (_, __) => FloatingActionButton(
        onPressed: onPressed,
        child: const Icon(Icons.add),
      ),
      cupertino: (_, __) => CupertinoButton.filled(
        onPressed: onPressed,
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(30),
        child: const Icon(
          CupertinoIcons.add,
          color: CupertinoColors.white,
        ),
      ),
    );
  }
}
