import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// Configuración de temas para la aplicación Todo Abstracta.
///
/// Define los colores, tipografías y estilos visuales tanto para
/// el tema claro como oscuro. Utiliza Material 3 y Google Fonts
/// para una apariencia moderna y consistente.
class AppTheme {
  /// Color principal de la aplicación.
  static const Color primaryColor = Color(0xFF6366F1);

  /// Color secundario de la aplicación.
  static const Color secondaryColor = Color(0xFF8B5CF6);

  /// Color para indicar éxito o completación.
  static const Color successColor = Color(0xFF10B981);

  /// Color para advertencias.
  static const Color warningColor = Color(0xFFF59E0B);

  /// Color para errores.
  static const Color errorColor = Color(0xFFEF4444);

  /// Tema claro de la aplicación.
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.interTextTheme(),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 1,
      titleTextStyle: GoogleFonts.inter(
          fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
      shape: CircleBorder(),
    ),
  );

  /// Tema oscuro de la aplicación.
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 1,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 4,
      shape: CircleBorder(),
    ),
  );
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// Notificador para el modo de tema de la aplicación.
///
/// Permite cambiar entre tema claro, oscuro y automático (sistema).
/// Proporciona métodos para establecer un modo específico o alternar
/// entre claro y oscuro.
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system);

  /// Establece un modo de tema específico.
  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  /// Alterna entre tema claro y oscuro.
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
