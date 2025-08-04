import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_abstracta_app/presentation/pages/statistics_page.dart';
import 'package:to_do_abstracta_app/presentation/widgets/platform_factory.dart';
import 'package:to_do_abstracta_app/presentation/widgets/platform_navigation.dart';
import 'package:to_do_abstracta_app/presentation/widgets/platform_task_handler.dart';
import 'package:to_do_abstracta_app/presentation/widgets/search_bar_widget.dart';
import 'package:to_do_abstracta_app/presentation/widgets/task_list_widget.dart';

/// Página principal de la aplicación Todo Abstracta.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformFactory.createScaffold(
      appBar: PlatformFactory.createAppBar(
        title: 'Todo Abstracta',
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              PlatformNavigation.pushPage(
                context,
                const StatisticsPage(),
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
      floatingActionButton: PlatformTaskFAB.create(),
    );
  }
}
