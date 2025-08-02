import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_abstracta_app/presentation/widgets/statistics_widget.dart';

/// Página que muestra las estadísticas de las tareas.
///
/// Proporciona una vista dedicada para visualizar métricas
/// y análisis sobre el progreso y estado de las tareas.
/// Utiliza el StatisticsWidget para mostrar los datos.
class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
      ),
      body: const StatisticsWidget(),
    );
  }
}
