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

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    final isVisible = ref.read(searchVisibilityProvider);
    if (isVisible) {
      _animationController.reverse().then((_) {
        _focusNode.unfocus();
        _searchController.clear();
        ref.read(searchQueryProvider.notifier).state = '';
        ref.read(searchVisibilityProvider.notifier).state = false;
      });
    } else {
      ref.read(searchVisibilityProvider.notifier).state = true;
      _animationController.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final isSearchVisible = ref.watch(searchVisibilityProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          if (isSearchVisible) {
            return _buildSearchField(searchQuery);
          } else {
            return _buildSearchButton();
          }
        },
      ),
    );
  }

  Widget _buildSearchButton() {
    final isIOS = Platform.isIOS;

    return GestureDetector(
      onTap: _toggleSearch,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 44,
        decoration: BoxDecoration(
          color: isIOS
              ? CupertinoColors.systemFill
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              isIOS ? CupertinoIcons.search : Icons.search,
              color: isIOS
                  ? CupertinoColors.systemGrey
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              'Buscar tareas...',
              style: TextStyle(
                color: isIOS
                    ? CupertinoColors.systemGrey
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(String searchQuery) {
    final isIOS = Platform.isIOS;

    return Transform.scale(
      scale: _scaleAnimation.value,
      child: Opacity(
        opacity: _fadeAnimation.value,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: isIOS
                ? CupertinoColors.systemBackground
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isIOS
                  ? CupertinoColors.systemGrey4
                  : Theme.of(context).colorScheme.outline,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(
                isIOS ? CupertinoIcons.search : Icons.search,
                color: isIOS
                    ? CupertinoColors.systemGrey
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: isIOS
                    ? _buildCupertinoTextField()
                    : _buildMaterialTextField(),
              ),
              if (searchQuery.isNotEmpty) ...[
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    ref.read(searchQueryProvider.notifier).state = '';
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      isIOS ? CupertinoIcons.xmark_circle_fill : Icons.clear,
                      color: isIOS
                          ? CupertinoColors.systemGrey
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],
              GestureDetector(
                onTap: _toggleSearch,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    isIOS ? CupertinoIcons.xmark : Icons.close,
                    color: isIOS
                        ? CupertinoColors.systemGrey
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCupertinoTextField() {
    return CupertinoTextField(
      controller: _searchController,
      focusNode: _focusNode,
      placeholder: 'Buscar...',
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      style: const TextStyle(fontSize: 16),
      onChanged: (value) {
        ref.read(searchQueryProvider.notifier).state = value;
      },
    );
  }

  Widget _buildMaterialTextField() {
    return TextField(
      controller: _searchController,
      focusNode: _focusNode,
      decoration: const InputDecoration(
        hintText: 'Buscar...',
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
      style: const TextStyle(fontSize: 16),
      onChanged: (value) {
        ref.read(searchQueryProvider.notifier).state = value;
      },
    );
  }
}
