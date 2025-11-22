import 'package:flutter/material.dart';

import '../hi_paws_theme.dart';

class HiPawsVideoPlaceholder extends StatelessWidget {
  const HiPawsVideoPlaceholder({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: HiPawsColors.videoPlaceholder,
          borderRadius: BorderRadius.circular(HiPawsSpacing.cardBorderRadius),
        ),
        alignment: Alignment.center,
        child: child ??
            const Icon(
              Icons.play_circle_outline,
              color: HiPawsColors.primaryOrange,
              size: 48,
            ),
      ),
    );
  }
}
