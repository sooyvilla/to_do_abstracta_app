import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_abstracta_app/core/extensions/task_extensions.dart';
import 'package:to_do_abstracta_app/data/models/task_model.dart';
import 'package:to_do_abstracta_app/presentation/providers/task_providers.dart';

/// Widget que muestra estadísticas visuales de las tareas.
///
/// Presenta métricas como total de tareas, tareas completadas,
/// pendientes, en progreso y canceladas. Incluye una barra de
/// progreso para la tasa de completación y gráficos visuales.
class StatisticsWidget extends ConsumerStatefulWidget {
  const StatisticsWidget({super.key});

  @override
  ConsumerState<StatisticsWidget> createState() => _StatisticsWidgetState();
}

class _StatisticsWidgetState extends ConsumerState<StatisticsWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(taskStatisticsProvider);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(taskStatisticsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statisticsAsync = ref.watch(taskStatisticsProvider);

    return statisticsAsync.when(
      data: (statistics) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen de Tareas',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Total',
                    statistics.total.toString(),
                    Icons.task_alt,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    TaskStatus.completed.label,
                    statistics.completed.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    TaskStatus.pending.label,
                    statistics.pending.toString(),
                    Icons.pending,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    TaskStatus.inProgress.label,
                    statistics.inProgress.toString(),
                    Icons.hourglass_empty,
                    Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tasa de Completación',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: statistics.completionRate,
                      backgroundColor: Colors.grey.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        statistics.completionRate > 0.7
                            ? Colors.green
                            : statistics.completionRate > 0.4
                                ? Colors.orange
                                : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(statistics.completionRate * 100).toStringAsFixed(1)}%',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distribución de Tareas',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildDistributionBar(
                      context,
                      TaskStatus.completed.label,
                      statistics.completed,
                      statistics.total,
                      Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _buildDistributionBar(
                      context,
                      TaskStatus.pending.label,
                      statistics.pending,
                      statistics.total,
                      Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    _buildDistributionBar(
                      context,
                      TaskStatus.inProgress.label,
                      statistics.inProgress,
                      statistics.total,
                      Colors.purple,
                    ),
                    const SizedBox(height: 12),
                    _buildDistributionBar(
                      context,
                      TaskStatus.cancelled.label,
                      statistics.cancelled,
                      statistics.total,
                      Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error cargando estadísticas',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionBar(
    BuildContext context,
    String label,
    int count,
    int total,
    Color color,
  ) {
    final percentage = total > 0 ? count / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              count.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey.withValues(alpha: 0.3),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }
}
