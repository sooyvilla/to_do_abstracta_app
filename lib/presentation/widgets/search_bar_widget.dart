import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_abstracta_app/presentation/providers/task_providers.dart';

/// Widget de barra de búsqueda para filtrar tareas.
///
/// El botón se transforma directamente en un campo de texto para buscar tareas
/// por título, descripción o etiquetas. El diseño se adapta a la plataforma
/// (Material Design para Android, Cupertino para iOS).
class SearchBarWidget extends ConsumerStatefulWidget {
  const SearchBarWidget({super.key});

  @override
  ConsumerState<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    final isVisible = ref.read(searchVisibilityProvider);

    if (isVisible) {
      _focusNode.unfocus();
      _searchController.clear();
      ref.read(searchQueryProvider.notifier).state = '';
      ref.read(searchVisibilityProvider.notifier).state = false;
    } else {
      ref.read(searchVisibilityProvider.notifier).state = true;
      Future.delayed(const Duration(milliseconds: 100), () {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final isSearchVisible = ref.watch(searchVisibilityProvider);
    final isIOS = Platform.isIOS;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: isSearchVisible
            ? (isIOS
                ? _buildCupertinoSearchField(searchQuery)
                : _buildMaterialSearchField(searchQuery))
            : (isIOS
                ? _buildCupertinoSearchButton()
                : _buildMaterialSearchButton()),
      ),
    );
  }

  Widget _buildMaterialSearchButton() {
    return SizedBox(
      key: const ValueKey('searchButton'),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _toggleSearch,
        icon: const Icon(Icons.search),
        label: const Text('Buscar tareas'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildCupertinoSearchButton() {
    return SizedBox(
      key: const ValueKey('searchButtonCupertino'),
      width: double.infinity,
      child: CupertinoButton.filled(
        onPressed: _toggleSearch,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        borderRadius: BorderRadius.circular(12),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.search,
              color: CupertinoColors.white,
            ),
            SizedBox(width: 8),
            Text(
              'Buscar tareas',
              style: TextStyle(
                color: CupertinoColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialSearchField(String searchQuery) {
    return TextField(
      key: const ValueKey('searchField'),
      controller: _searchController,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: 'Buscar tareas...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (searchQuery.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  ref.read(searchQueryProvider.notifier).state = '';
                },
              ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _toggleSearch,
            ),
          ],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      onChanged: (value) {
        ref.read(searchQueryProvider.notifier).state = value;
      },
    );
  }

  Widget _buildCupertinoSearchField(String searchQuery) {
    return Row(
      key: const ValueKey('searchFieldCupertino'),
      children: [
        Expanded(
          child: CupertinoSearchTextField(
            controller: _searchController,
            focusNode: _focusNode,
            placeholder: 'Buscar tareas...',
            style: CupertinoTheme.of(context).textTheme.textStyle,
            decoration: BoxDecoration(
              color: CupertinoColors.systemGroupedBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: CupertinoColors.systemGrey4,
              ),
            ),
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
            onSuffixTap: () {
              _searchController.clear();
              ref.read(searchQueryProvider.notifier).state = '';
            },
          ),
        ),
        const SizedBox(width: 8),
        CupertinoButton(
          padding: const EdgeInsets.all(8),
          onPressed: _toggleSearch,
          child: const Icon(
            CupertinoIcons.xmark_circle_fill,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ],
    );
  }
}
