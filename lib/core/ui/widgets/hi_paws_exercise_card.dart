import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/favorites_controller.dart';
import '../../../models/exercise.dart';
import '../hi_paws_theme.dart';
import 'hi_paws_chip.dart';

class HiPawsExerciseCard extends ConsumerWidget {
  const HiPawsExerciseCard({
    super.key,
    required this.exercise,
    this.onTap,
  });

  final Exercise exercise;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesControllerProvider).favorites;
    final isFavorite = favorites.any((fav) => fav.exerciseId == exercise.id);
    final authState = ref.watch(authControllerProvider);
    return GestureDetector(
      onTap: onTap ??
          () {
            context.push('/exercise/${exercise.id}');
          },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: HiPawsColors.primaryOrange,
          borderRadius: BorderRadius.circular(HiPawsSpacing.cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: HiPawsColors.primaryOrange.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    exercise.title,
                    style: HiPawsTextStyles.sectionTitle.copyWith(color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: authState.user == null
                      ? null
                      : () => ref.read(favoritesControllerProvider.notifier).toggleFavorite(exercise),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? HiPawsColors.accentMint : HiPawsColors.primaryNavy,
                          size: 18,
                        ),
                      ),
                      if (isFavorite)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: HiPawsColors.accentMint,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              exercise.subtitle,
              style: HiPawsTextStyles.body.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: exercise.pillars
                  .map((pillar) => HiPawsChip(label: pillar.name))
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }
}
