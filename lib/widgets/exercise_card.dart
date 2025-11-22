import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/auth_controller.dart';
import '../controllers/favorites_controller.dart';
import '../core/constants/app_colors.dart';
import '../core/extensions/pillar_localization_extension.dart';
import '../l10n/app_localizations.dart';
import '../models/exercise.dart';

class ExerciseCard extends ConsumerWidget {
  const ExerciseCard({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesControllerProvider);
    final isFavorite =
        favorites.favorites.any((fav) => fav.exerciseId == exercise.id);
    final authState = ref.watch(authControllerProvider);
    final l10n = AppLocalizations.of(context);
    final levelLabels = {
      'inicial': l10n.translate('level_initial'),
      'intermediário': l10n.translate('level_intermediate'),
      'avançado': l10n.translate('level_advanced'),
    };
    final borderRadius = BorderRadius.circular(26);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () => context.push('/exercise/${exercise.id}'),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFBC78D), AppColors.orange],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: AppColors.orange.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    exercise.subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white.withOpacity(0.92)),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      for (final pillar in exercise.pillars)
                        _Tag(label: pillar.localizedLabel(l10n), dark: false),
                      for (final level in exercise.levels)
                        _Tag(label: levelLabels[level] ?? level, dark: true),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: InkResponse(
                  radius: 28,
                  highlightColor: Colors.white24,
                  onTap: authState.user == null
                      ? null
                      : () => ref
                          .read(favoritesControllerProvider.notifier)
                          .toggleFavorite(exercise),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: AppColors.darkBlue,
                    ),
                  ),
                ),
              ),
              if (exercise.difficulty == 'custom')
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Hi!Paws',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.dark});

  final String label;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: dark
            ? Colors.white.withOpacity(0.18)
            : Colors.white.withOpacity(0.28),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
