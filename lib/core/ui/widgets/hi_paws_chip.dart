import 'package:flutter/material.dart';

import '../hi_paws_theme.dart';

class HiPawsChip extends StatelessWidget {
  const HiPawsChip({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: HiPawsColors.chipBackground,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(label, style: HiPawsTextStyles.chip),
    );
    if (onTap == null) return chip;
    return GestureDetector(onTap: onTap, child: chip);
  }
}
