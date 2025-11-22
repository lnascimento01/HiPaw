import 'package:flutter/material.dart';

import '../core/ui/hi_paws_theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 96, required this.title});

  final double size;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: size,
          width: size,
          decoration: const BoxDecoration(
            color: HiPawsColors.primaryOrange,
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: const [
              Icon(Icons.front_hand, color: Colors.white, size: 56),
              Positioned(
                bottom: 26,
                right: 30,
                child: Icon(Icons.pets, color: Colors.white, size: 28),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: HiPawsTextStyles.logo.copyWith(fontSize: 24),
        ),
      ],
    );
  }
}
