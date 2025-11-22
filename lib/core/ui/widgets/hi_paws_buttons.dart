import 'package:flutter/material.dart';

import '../hi_paws_theme.dart';

class HiPawsPrimaryButton extends StatelessWidget {
  const HiPawsPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon, color: Colors.white) : const SizedBox.shrink(),
        label: Text(label.toUpperCase(), style: HiPawsTextStyles.buttonText),
        style: ElevatedButton.styleFrom(
          backgroundColor: HiPawsColors.primaryOrange,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HiPawsSpacing.cardBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          shadowColor: HiPawsColors.primaryOrange.withOpacity(0.35),
        ),
      ),
    );
  }
}

class HiPawsSecondaryButton extends StatelessWidget {
  const HiPawsSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: HiPawsColors.accentMint,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HiPawsSpacing.cardBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          shadowColor: HiPawsColors.accentMint.withOpacity(0.35),
        ),
        child: Text(label.toUpperCase(), style: HiPawsTextStyles.buttonText),
      ),
    );
  }
}
