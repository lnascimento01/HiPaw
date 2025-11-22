import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.dashboard_outlined), label: l10n.translate('admin_dashboard')),
          NavigationDestination(icon: const Icon(Icons.fitness_center), label: l10n.translate('admin_manage_exercises')),
          NavigationDestination(icon: const Icon(Icons.group_outlined), label: l10n.translate('admin_users')),
          NavigationDestination(icon: const Icon(Icons.reviews_outlined), label: l10n.translate('admin_feedbacks')),
          NavigationDestination(icon: const Icon(Icons.category_outlined), label: l10n.translate('admin_categories')),
          NavigationDestination(icon: const Icon(Icons.settings_outlined), label: l10n.translate('admin_settings')),
        ],
      ),
    );
  }
}
