import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/exercise_controller.dart';
import '../../controllers/recent_controller.dart';
import '../../core/ui/hi_paws_theme.dart';
import '../../core/ui/widgets/hi_paws_buttons.dart';
import '../../core/ui/widgets/hi_paws_pattern_background.dart';
import '../../core/ui/widgets/hi_paws_sections.dart';
import '../../core/ui/widgets/hi_paws_video_placeholder.dart';
import '../../l10n/app_localizations.dart';
import '../../models/exercise.dart';
import '../../widgets/exercise_video_player.dart';

class ExerciseLevelView extends ConsumerWidget {
  const ExerciseLevelView({
    super.key,
    required this.exerciseId,
    required this.level,
  });

  final String exerciseId;
  final String level;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercises = ref.watch(exerciseControllerProvider).exercises;
    Exercise? exercise;
    for (final item in exercises) {
      if (item.id == exerciseId) {
        exercise = item;
        break;
      }
    }
    final l10n = AppLocalizations.of(context);
    if (exercise == null) {
      return Scaffold(
        body: Center(child: Text(l10n.translate('exercise_not_found'))),
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(recentControllerProvider.notifier)
          .markPendingFeedback(exerciseId);
    });

    final title = switch (level) {
      'intermediate' => l10n.translate('level_intermediate'),
      'advanced' => l10n.translate('level_advanced'),
      _ => l10n.translate('level_initial'),
    };

    List<String> materials;
    List<String> steps;
    String description;
    String notes;
    switch (level) {
      case 'intermediate':
        materials = exercise.materialsIntermediate;
        steps = exercise.stepsIntermediate;
        description = exercise.descriptionIntermediate;
        notes = exercise.notesIntermediate;
        break;
      case 'advanced':
        materials = exercise.materialsAdvanced;
        steps = exercise.stepsAdvanced;
        description = exercise.descriptionAdvanced;
        notes = exercise.notesAdvanced;
        break;
      default:
        materials = exercise.materialsInitial;
        steps = exercise.stepsInitial;
        description = exercise.descriptionInitial;
        notes = exercise.notesInitial;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.title, style: HiPawsTextStyles.sectionTitle),
        backgroundColor: Colors.white,
      ),
      body: HiPawsPatternBackground(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(title, style: HiPawsTextStyles.screenTitle),
            const SizedBox(height: 8),
            HiPawsOrangeLabel(l10n.translate('objective')),
            const SizedBox(height: 6),
            Text(exercise.subtitle, style: HiPawsTextStyles.body),
            const SizedBox(height: 24),
            HiPawsOrangeLabel(l10n.translate('materials')),
            const SizedBox(height: 8),
            if (materials.isEmpty)
              Text(l10n.translate('empty_materials'),
                  style: HiPawsTextStyles.body)
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: materials
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('• $item', style: HiPawsTextStyles.body),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 24),
            HiPawsOrangeLabel(l10n.translate('dynamics')),
            const SizedBox(height: 6),
            Text(
              description.isEmpty
                  ? l10n.translate('empty_description')
                  : description,
              style: HiPawsTextStyles.body,
            ),
            const SizedBox(height: 24),
            HiPawsOrangeLabel(l10n.translate('commands')),
            const SizedBox(height: 6),
            if (steps.isEmpty)
              Text(l10n.translate('empty_steps'), style: HiPawsTextStyles.body)
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: steps
                    .asMap()
                    .entries
                    .map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '${entry.key + 1}. ${entry.value}',
                          style: HiPawsTextStyles.body,
                        ),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 24),
            HiPawsSectionTitle(l10n.translate('positioning')),
            const SizedBox(height: 6),
            Text(
              notes.isEmpty ? l10n.translate('empty_notes') : notes,
              style: HiPawsTextStyles.body,
            ),
            const SizedBox(height: 24),
            HiPawsSectionTitle(l10n.translate('video')),
            const SizedBox(height: 12),
            if (exercise.videoUrl.isNotEmpty)
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(HiPawsSpacing.cardBorderRadius),
                child: ExerciseVideoPlayer(url: exercise.videoUrl),
              )
            else
              const HiPawsVideoPlaceholder(),
            const SizedBox(height: 24),
            HiPawsPrimaryButton(
              label: l10n.translate('send_feedback'),
              icon: Icons.feedback_outlined,
              onPressed: () =>
                  context.push('/exercise/$exerciseId/feedback?level=$level'),
            ),
          ],
        ),
      ),
    );
  }
}
