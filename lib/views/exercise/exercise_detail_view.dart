import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/exercise_controller.dart';
import '../../controllers/recent_controller.dart';
import '../../core/extensions/pillar_localization_extension.dart';
import '../../core/constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../models/exercise.dart';
import '../../widgets/themed_buttons.dart';
import '../../widgets/themed_chip.dart';

class ExerciseDetailView extends ConsumerWidget {
  const ExerciseDetailView({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercises = ref.watch(exerciseControllerProvider).exercises;
    final exercise = exercises.cast<Exercise?>().firstWhere(
          (item) => item?.id == exerciseId,
          orElse: () => null,
        );
    final l10n = AppLocalizations.of(context);
    if (exercise == null) {
      return Scaffold(
          body: Center(child: Text(l10n.translate('exercise_not_found'))));
    }
    final selectedExercise = exercise!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recentControllerProvider.notifier).addRecent(exerciseId);
    });
    final levels = [
      {
        'label': l10n.translate('level_initial'),
        'key': 'initial',
        'summary': selectedExercise.descriptionInitial,
      },
      {
        'label': l10n.translate('level_intermediate'),
        'key': 'intermediate',
        'summary': selectedExercise.descriptionIntermediate,
      },
      {
        'label': l10n.translate('level_advanced'),
        'key': 'advanced',
        'summary': selectedExercise.descriptionAdvanced,
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedExercise.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.translate('objective'),
            style: const TextStyle(
              color: AppColors.orange,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            selectedExercise.subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.darkBlue, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.translate('psychomotor_pillars'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.darkBlue, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final pillar in selectedExercise.pillars)
                ThemedChip(label: pillar.localizedLabel(l10n), selected: false),
            ],
          ),
          const SizedBox(height: 30),
          ...levels.map(
            (level) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: OrangeButton(
                label: level['label']! as String,
                onPressed: () => context.push(
                    '/exercise/${selectedExercise.id}/level/${level['key']}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
