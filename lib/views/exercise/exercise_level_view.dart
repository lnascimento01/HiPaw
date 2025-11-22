import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/exercise_controller.dart';
import '../../controllers/recent_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../models/exercise.dart';
import '../../widgets/exercise_video_player.dart';
import '../../widgets/themed_buttons.dart';

class ExerciseLevelView extends ConsumerWidget {
  const ExerciseLevelView(
      {super.key, required this.exerciseId, required this.level});

  final String exerciseId;
  final String level;

  String _title(String level, AppLocalizations l10n) {
    switch (level) {
      case 'intermediate':
        return l10n.translate('level_intermediate');
      case 'advanced':
        return l10n.translate('level_advanced');
      default:
        return l10n.translate('level_initial');
    }
  }

  List<String> _materials(Exercise exercise) {
    switch (level) {
      case 'intermediate':
        return exercise.materialsIntermediate;
      case 'advanced':
        return exercise.materialsAdvanced;
      default:
        return exercise.materialsInitial;
    }
  }

  List<String> _steps(Exercise exercise) {
    switch (level) {
      case 'intermediate':
        return exercise.stepsIntermediate;
      case 'advanced':
        return exercise.stepsAdvanced;
      default:
        return exercise.stepsInitial;
    }
  }

  String _description(Exercise exercise) {
    switch (level) {
      case 'intermediate':
        return exercise.descriptionIntermediate;
      case 'advanced':
        return exercise.descriptionAdvanced;
      default:
        return exercise.descriptionInitial;
    }
  }

  String _notes(Exercise exercise) {
    switch (level) {
      case 'intermediate':
        return exercise.notesIntermediate;
      case 'advanced':
        return exercise.notesAdvanced;
      default:
        return exercise.notesInitial;
    }
  }

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
          body: Center(child: Text(l10n.translate('exercise_not_found'))));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(recentControllerProvider.notifier)
          .markPendingFeedback(exerciseId);
    });
    final materials = _materials(exercise);
    final steps = _steps(exercise);
    final notes = _notes(exercise);
    final description = _description(exercise);
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.title),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            _title(level, l10n),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.translate('level_goal_label'),
            style: const TextStyle(
                color: AppColors.orange, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(exercise.subtitle,
              style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          _SectionBlock(
            title: l10n.translate('materials'),
            child: materials.isEmpty
                ? Text(l10n.translate('empty_materials'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: materials
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.circle,
                                    size: 10, color: AppColors.orange),
                                const SizedBox(width: 8),
                                Expanded(child: Text(item)),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
          _SectionBlock(
            title: l10n.translate('dynamics'),
            child: Text(description.isEmpty
                ? l10n.translate('empty_description')
                : description),
          ),
          _SectionBlock(
            title: l10n.translate('commands'),
            child: steps.isEmpty
                ? Text(l10n.translate('empty_steps'))
                : Column(
                    children: steps
                        .asMap()
                        .entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: AppColors.orange,
                                  foregroundColor: Colors.white,
                                  child: Text('${entry.key + 1}'),
                                ),
                                const SizedBox(width: 10),
                                Expanded(child: Text(entry.value)),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
          _SectionBlock(
            title: l10n.translate('positioning'),
            child: Text(notes.isEmpty ? l10n.translate('empty_notes') : notes),
          ),
          _SectionBlock(
            title: l10n.translate('video'),
            child: exercise.videoUrl.isNotEmpty
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.orange, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: ExerciseVideoPlayer(url: exercise.videoUrl),
                    ),
                  )
                : _VideoPlaceholder(),
          ),
          const SizedBox(height: 12),
          OrangeButton(
            label: l10n.translate('send_feedback'),
            onPressed: () =>
                context.push('/exercise/$exerciseId/feedback?level=$level'),
            icon: Icons.feedback_outlined,
          ),
        ],
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.softLilac),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _VideoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFDE9D2),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.orange.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.play_circle_outline, color: AppColors.orange, size: 48),
            SizedBox(height: 8),
            Text(
              'Hi!Paws',
              style: TextStyle(
                  color: AppColors.orange, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
