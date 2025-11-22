import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/ui/widgets/hi_paws_bottom_navigation_bar.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: HiPawsBottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onItemSelected: _goBranch,
      ),
    );
  }
}
