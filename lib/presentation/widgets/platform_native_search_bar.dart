import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_abstracta_app/presentation/providers/task_providers.dart';

/// Search bar nativo que imita el estilo de iOS/Android
class PlatformNativeSearchBar extends ConsumerStatefulWidget {
  const PlatformNativeSearchBar({super.key});

  @override
  ConsumerState<PlatformNativeSearchBar> createState() =>
      _PlatformNativeSearchBarState();
}

class _PlatformNativeSearchBarState
    extends ConsumerState<PlatformNativeSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearchVisible = ref.watch(searchVisibilityProvider);
    final isIOS = Platform.isIOS;

    if (!isSearchVisible) {
      ref.read(searchQueryProvider.notifier).state = '';
      return const SizedBox.shrink();
    }

    if (isIOS) {
      return _buildIOSSearchBar();
    } else {
      return _buildAndroidSearchBar();
    }
  }

  Widget _buildIOSSearchBar() {
    return Container(
      color: CupertinoColors.systemBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: CupertinoColors.tertiarySystemFill,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(
                CupertinoIcons.search,
                color: CupertinoColors.secondaryLabel,
                size: 18,
              ),
            ),
            Expanded(
              child: CupertinoTextField(
                autofocus: true,
                controller: _searchController,
                focusNode: _focusNode,
                placeholder: 'Buscar',
                placeholderStyle: const TextStyle(
                  color: CupertinoColors.placeholderText,
                  fontSize: 17,
                ),
                style: const TextStyle(
                  color: CupertinoColors.label,
                  fontSize: 17,
                ),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                  setState(() {});
                },
              ),
            ),
            if (_searchController.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  ref.read(searchQueryProvider.notifier).state = '';
                  setState(() {});
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: CupertinoColors.secondaryLabel,
                    size: 18,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAndroidSearchBar() {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Buscar tareas...',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(searchQueryProvider.notifier).state = '';
                      setState(() {});
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
            setState(() {});
          },
        ),
      ),
    );
  }
}
