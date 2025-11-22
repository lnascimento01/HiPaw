import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/exercise_controller.dart';
import '../../controllers/recent_controller.dart';
import '../../core/extensions/pillar_localization_extension.dart';
import '../../core/ui/hi_paws_theme.dart';
import '../../core/ui/widgets/hi_paws_buttons.dart';
import '../../core/ui/widgets/hi_paws_chip.dart';
import '../../core/ui/widgets/hi_paws_pattern_background.dart';
import '../../core/ui/widgets/hi_paws_sections.dart';
import '../../l10n/app_localizations.dart';
import '../../models/exercise.dart';

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
        body: Center(child: Text(l10n.translate('exercise_not_found'))),
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recentControllerProvider.notifier).addRecent(exerciseId);
    });
    final levels = [
      {
        'label': l10n.translate('level_initial'),
        'key': 'initial',
      },
      {
        'label': l10n.translate('level_intermediate'),
        'key': 'intermediate',
      },
      {
        'label': l10n.translate('level_advanced'),
        'key': 'advanced',
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.title, style: HiPawsTextStyles.sectionTitle),
        backgroundColor: Colors.white,
      ),
      body: HiPawsPatternBackground(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            HiPawsOrangeLabel(l10n.translate('objective')),
            const SizedBox(height: 6),
            Text(exercise.subtitle, style: HiPawsTextStyles.body),
            const SizedBox(height: 24),
            HiPawsSectionTitle(l10n.translate('psychomotor_pillars')),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final pillar in exercise.pillars)
                  HiPawsChip(label: pillar.localizedLabel(l10n)),
              ],
            ),
            const SizedBox(height: 32),
            for (final level in levels) ...[
              HiPawsPrimaryButton(
                label: level['label']! as String,
                onPressed: () => context
                    .push('/exercise/${exercise.id}/level/${level['key']}'),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}
