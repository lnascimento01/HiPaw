import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class ThemedChip extends StatelessWidget {
  const ThemedChip({super.key, required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(26);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.darkBlue : const Color(0xFFFDE9D2),
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(selected ? 0.18 : 0.08),
            blurRadius: selected ? 18 : 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : AppColors.orange,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
