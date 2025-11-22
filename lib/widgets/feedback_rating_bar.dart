import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class FeedbackRatingBar extends StatelessWidget {
  const FeedbackRatingBar(
      {super.key, required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(5, (index) {
        final selected = value == index + 1;
        final borderRadius = BorderRadius.circular(18);
        return GestureDetector(
          onTap: () => onChanged(index + 1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: selected
                  ? const LinearGradient(
                      colors: [Color(0xFFFBD7B1), AppColors.orange],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  : null,
              color: selected ? null : Colors.white,
              border: Border.all(
                  color: selected ? Colors.transparent : AppColors.softLilac),
              boxShadow: [
                BoxShadow(
                  color: AppColors.orange.withOpacity(selected ? 0.35 : 0.15),
                  blurRadius: selected ? 16 : 8,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (inner) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    Icons.star,
                    size: 18,
                    color: inner < index + 1
                        ? (selected ? Colors.white : AppColors.orange)
                        : (selected ? Colors.white70 : AppColors.softLilac),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
