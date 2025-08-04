import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Botón adaptable a la plataforma que mantiene el diseño nativo.
///
/// En Android usa Material Design components.
/// En iOS usa Cupertino components.
class PlatformButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final PlatformButtonType type;
  final IconData? icon;
  final bool isLoading;
  final Color? color;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const PlatformButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = PlatformButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.color,
    this.textColor,
    this.padding,
    this.borderRadius,
  });

  /// Factory method para crear un botón primario
  factory PlatformButton.primary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    Color? color,
  }) {
    return PlatformButton(
      text: text,
      onPressed: onPressed,
      type: PlatformButtonType.primary,
      icon: icon,
      isLoading: isLoading,
      color: color,
    );
  }

  /// Factory method para crear un botón secundario
  factory PlatformButton.secondary({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    Color? textColor,
  }) {
    return PlatformButton(
      text: text,
      onPressed: onPressed,
      type: PlatformButtonType.secondary,
      icon: icon,
      isLoading: isLoading,
      textColor: textColor,
    );
  }

  /// Factory method para crear un botón de texto
  factory PlatformButton.text({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    Color? textColor,
  }) {
    return PlatformButton(
      text: text,
      onPressed: onPressed,
      type: PlatformButtonType.text,
      icon: icon,
      textColor: textColor,
    );
  }

  /// Factory method para crear un botón destructivo
  factory PlatformButton.destructive({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
  }) {
    return PlatformButton(
      text: text,
      onPressed: onPressed,
      type: PlatformButtonType.destructive,
      icon: icon,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingButton(context);
    }

    if (Platform.isIOS) {
      return _buildCupertinoButton(context);
    } else {
      return _buildMaterialButton(context);
    }
  }

  Widget _buildLoadingButton(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoButton(
        onPressed: null,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        color: color ?? CupertinoColors.systemGrey,
        child: const CupertinoActivityIndicator(color: CupertinoColors.white),
      );
    } else {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
        ),
        child: const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
  }

  Widget _buildCupertinoButton(BuildContext context) {
    Widget child = Text(
      text,
      style: TextStyle(color: textColor ?? CupertinoColors.white),
    );

    if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor ?? CupertinoColors.white),
          const SizedBox(width: 8),
          child,
        ],
      );
    }

    switch (type) {
      case PlatformButtonType.primary:
        return CupertinoButton.filled(
          onPressed: onPressed,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          color: color,
          child: child,
        );
      case PlatformButtonType.secondary:
        return CupertinoButton(
          onPressed: onPressed,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          color: color ?? CupertinoColors.systemGrey6,
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? CupertinoColors.label,
            ),
          ),
        );
      case PlatformButtonType.text:
        return CupertinoButton(
          onPressed: onPressed,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? CupertinoColors.activeBlue,
            ),
          ),
        );
      case PlatformButtonType.destructive:
        return CupertinoButton.filled(
          onPressed: onPressed,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          color: color ?? CupertinoColors.destructiveRed,
          child: child,
        );
    }
  }

  Widget _buildMaterialButton(BuildContext context) {
    Widget child = Text(text);

    if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          child,
        ],
      );
    }

    switch (type) {
      case PlatformButtonType.primary:
        return icon != null
            ? ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon),
                label: Text(text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: textColor,
                  padding: padding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(8),
                  ),
                ),
              )
            : ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: textColor,
                  padding: padding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(8),
                  ),
                ),
                child: child,
              );
      case PlatformButtonType.secondary:
        return icon != null
            ? OutlinedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon),
                label: Text(text),
                style: OutlinedButton.styleFrom(
                  foregroundColor: textColor,
                  padding: padding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(8),
                  ),
                ),
              )
            : OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: textColor,
                  padding: padding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(8),
                  ),
                ),
                child: child,
              );
      case PlatformButtonType.text:
        return icon != null
            ? TextButton.icon(
                onPressed: onPressed,
                icon: Icon(icon),
                label: Text(text),
                style: TextButton.styleFrom(
                  foregroundColor: textColor,
                  padding: padding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              )
            : TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  foregroundColor: textColor,
                  padding: padding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: child,
              );
      case PlatformButtonType.destructive:
        return icon != null
            ? ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon),
                label: Text(text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color ?? Colors.red,
                  foregroundColor: textColor ?? Colors.white,
                  padding: padding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(8),
                  ),
                ),
              )
            : ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color ?? Colors.red,
                  foregroundColor: textColor ?? Colors.white,
                  padding: padding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(8),
                  ),
                ),
                child: child,
              );
    }
  }
}

enum PlatformButtonType {
  primary,
  secondary,
  text,
  destructive,
}

/// Widget de indicador de carga adaptable a la plataforma.
class PlatformLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? size;

  const PlatformLoadingIndicator({
    super.key,
    this.color,
    this.size,
  });

  /// Factory method para crear un indicador básico
  factory PlatformLoadingIndicator.basic() {
    return const PlatformLoadingIndicator();
  }

  /// Factory method para crear un indicador pequeño
  factory PlatformLoadingIndicator.small({
    Color? color,
  }) {
    return PlatformLoadingIndicator(
      size: 16,
      color: color,
    );
  }

  /// Factory method para crear un indicador grande
  factory PlatformLoadingIndicator.large({
    Color? color,
  }) {
    return PlatformLoadingIndicator(
      size: 32,
      color: color,
    );
  }

  /// Factory method para crear un indicador con color personalizado
  factory PlatformLoadingIndicator.colored({
    required Color color,
    double? size,
  }) {
    return PlatformLoadingIndicator(
      color: color,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoActivityIndicator(
        color: color ?? CupertinoColors.activeBlue,
        radius: size != null ? size! / 2 : 10,
      );
    } else {
      return SizedBox(
        width: size ?? 20,
        height: size ?? 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: color != null ? AlwaysStoppedAnimation(color) : null,
        ),
      );
    }
  }
}
