import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/exercise_controller.dart';
import '../../controllers/feedback_controller.dart';
import '../../core/ui/hi_paws_theme.dart';
import '../../core/ui/widgets/hi_paws_buttons.dart';
import '../../core/ui/widgets/hi_paws_pattern_background.dart';
import '../../core/ui/widgets/hi_paws_rating_bar.dart';
import '../../l10n/app_localizations.dart';
import '../../models/exercise.dart';

class ExerciseFeedbackView extends ConsumerStatefulWidget {
  const ExerciseFeedbackView({super.key, required this.exerciseId, this.level});

  final String exerciseId;
  final String? level;

  @override
  ConsumerState<ExerciseFeedbackView> createState() =>
      _ExerciseFeedbackViewState();
}

class _ExerciseFeedbackViewState extends ConsumerState<ExerciseFeedbackView> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authControllerProvider);
    if (auth.user == null) {
      return Scaffold(
        body: Center(child: Text(l10n.translate('visitor_warning'))),
      );
    }
    final exercises = ref.watch(exerciseControllerProvider).exercises;
    final exercise = exercises.cast<Exercise?>().firstWhere(
          (item) => item?.id == widget.exerciseId,
          orElse: () => null,
        );
    if (exercise == null) {
      return Scaffold(
        body: Center(child: Text(l10n.translate('exercise_not_found'))),
      );
    }
    final form = ref.watch(feedbackFormControllerProvider);
    final notifier = ref.read(feedbackFormControllerProvider.notifier);
    final subtitle = switch (widget.level) {
      'intermediate' => l10n.translate('level_intermediate'),
      'advanced' => l10n.translate('level_advanced'),
      _ => l10n.translate('level_initial'),
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('feedback')),
        backgroundColor: Colors.white,
      ),
      body: HiPawsPatternBackground(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(exercise.title, style: HiPawsTextStyles.sectionTitle),
            const SizedBox(height: 4),
            Text(subtitle, style: HiPawsTextStyles.orangeSectionLabel),
            const SizedBox(height: 20),
            Text(
              l10n.translate('feedback_question'),
              style: HiPawsTextStyles.sectionTitle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),
            HiPawsRatingBarRow(
              max: 5,
              value: form.rating,
              onChanged: notifier.updateRating,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.translate('feedback_importance'),
              style: HiPawsTextStyles.sectionTitle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: notifier.updateComment,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: l10n.translate('feedback_placeholder'),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(HiPawsSpacing.cardBorderRadius),
                ),
              ),
            ),
            const SizedBox(height: 24),
            HiPawsPrimaryButton(
              label: l10n.translate('feedback_send'),
              onPressed: form.submitting
                  ? null
                  : () async {
                      if (form.rating == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.translate('feedback_rating_required'),
                            ),
                          ),
                        );
                        return;
                      }
                      await notifier.submit(
                        exerciseId: widget.exerciseId,
                        level: widget.level ?? 'initial',
                      );
                      if (mounted) Navigator.of(context).pop();
                    },
            ),
            if (form.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(form.error!,
                    style: const TextStyle(color: Colors.red)),
              ),
            if (form.success)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(l10n.translate('feedback_success')),
              ),
          ],
        ),
      ),
    );
  }
}
