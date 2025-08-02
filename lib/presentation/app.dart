import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_abstracta_app/core/theme/app_theme.dart';
import 'package:to_do_abstracta_app/presentation/pages/home_page.dart';

/// Widget principal de la aplicación Todo Abstracta.
///
/// Configura el tema de la aplicación y la página inicial.
/// Utiliza Riverpod para el manejo de estado y soporta
/// tanto tema claro como oscuro.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Todo Abstracta App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
