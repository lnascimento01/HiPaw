import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class OrangeButton extends StatelessWidget {
  const OrangeButton(
      {super.key, required this.label, required this.onPressed, this.icon});

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    final borderRadius = BorderRadius.circular(22);
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: isEnabled
                ? const LinearGradient(
                    colors: [Color(0xFFFBD7B1), Color(0xFFF7931E)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
            color: isEnabled ? null : AppColors.softLilac,
            borderRadius: borderRadius,
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: AppColors.orange.withOpacity(0.45),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GreenButton extends StatelessWidget {
  const GreenButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    final borderRadius = BorderRadius.circular(22);
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: isEnabled ? AppColors.pastelGreen : AppColors.softLilac,
            borderRadius: borderRadius,
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: AppColors.pastelGreen.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              alignment: Alignment.center,
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
