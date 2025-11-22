import 'package:flutter/material.dart';

import '../hi_paws_theme.dart';

class HiPawsBottomNavigationBar extends StatelessWidget {
  const HiPawsBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Container(
          height: HiPawsSpacing.bottomNavHeight,
          decoration: BoxDecoration(
            color: HiPawsColors.bottomNavBackground,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: HiPawsColors.bottomNavBackground.withOpacity(0.25),
                blurRadius: 18,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                icon: Icons.home_filled,
                index: 0,
                isActive: currentIndex == 0,
                onTap: onItemSelected,
              ),
              _NavItem(
                icon: Icons.pets,
                index: 1,
                isActive: currentIndex == 1,
                onTap: onItemSelected,
              ),
              _NavItem(
                icon: Icons.favorite,
                index: 2,
                isActive: currentIndex == 2,
                onTap: onItemSelected,
              ),
              _NavItem(
                icon: Icons.settings,
                index: 3,
                isActive: currentIndex == 3,
                onTap: onItemSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final int index;
  final bool isActive;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? HiPawsColors.iconActive
        : HiPawsColors.iconInactive.withOpacity(0.6);
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? HiPawsColors.iconActive : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
