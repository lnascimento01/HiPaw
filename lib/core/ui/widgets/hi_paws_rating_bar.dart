import 'package:flutter/material.dart';

import '../hi_paws_theme.dart';

class HiPawsRatingBarRow extends StatelessWidget {
  const HiPawsRatingBarRow({
    super.key,
    required this.max,
    required this.value,
    required this.onChanged,
  });

  final int max;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: HiPawsColors.ratingInactive,
          borderRadius: BorderRadius.circular(HiPawsSpacing.cardBorderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            max,
            (index) => GestureDetector(
              onTap: () => onChanged(index + 1),
              child: Icon(
                Icons.star,
                size: 22,
                color:
                    index < value ? HiPawsColors.primaryOrange : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
