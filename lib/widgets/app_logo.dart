import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

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
            color: AppColors.orange,
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
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.darkBlue,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
