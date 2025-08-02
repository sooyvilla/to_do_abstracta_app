import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_abstracta_app/presentation/pages/statistics_page.dart';
import 'package:to_do_abstracta_app/presentation/pages/task_form_page.dart';
import 'package:to_do_abstracta_app/presentation/widgets/platform_fab.dart';
import 'package:to_do_abstracta_app/presentation/widgets/search_bar_widget.dart';
import 'package:to_do_abstracta_app/presentation/widgets/task_list_widget.dart';

/// Página principal de la aplicación Todo Abstracta.
///
/// Muestra la lista de tareas con opciones para navegar a las estadísticas
/// y crear nuevas tareas. Incluye un AppBar con acceso a estadísticas
/// y un FloatingActionButton para agregar tareas.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Abstracta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SearchBarWidget(),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                return const TaskListWidget();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: PlatformFAB(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormPage(),
            ),
          );
        },
      ),
    );
  }
}
