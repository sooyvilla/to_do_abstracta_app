import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_abstracta_app/presentation/widgets/platform_factory.dart';
import 'package:to_do_abstracta_app/presentation/widgets/statistics_widget.dart';

/// Página que muestra las estadísticas de las tareas.
class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformFactory.createScaffold(
      appBar: PlatformFactory.createAppBar(
        title: 'Estadísticas',
      ),
      body: const StatisticsWidget(),
    );
  }
}
