import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/exercise_controller.dart';
import '../../controllers/feedback_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../models/exercise.dart';
import '../../widgets/feedback_rating_bar.dart';
import '../../widgets/themed_buttons.dart';

class ExerciseFeedbackView extends ConsumerStatefulWidget {
  const ExerciseFeedbackView({super.key, required this.exerciseId, this.level});

  final String exerciseId;
  final String? level;

  @override
  ConsumerState<ExerciseFeedbackView> createState() =>
      _ExerciseFeedbackViewState();
}

class _ExerciseFeedbackViewState extends ConsumerState<ExerciseFeedbackView> {
  late String _selectedLevel;

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.level ?? 'initial';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authControllerProvider);
    if (auth.user == null) {
      return Scaffold(
          body: Center(child: Text(l10n.translate('visitor_warning'))));
    }
    final exercises = ref.watch(exerciseControllerProvider).exercises;
    final exercise = exercises.cast<Exercise?>().firstWhere(
          (item) => item?.id == widget.exerciseId,
          orElse: () => null,
        );
    if (exercise == null) {
      return Scaffold(
          body: Center(child: Text(l10n.translate('exercise_not_found'))));
    }
    final form = ref.watch(feedbackFormControllerProvider);
    final notifier = ref.read(feedbackFormControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('feedback')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            exercise.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.level == 'intermediate'
                ? l10n.translate('level_intermediate')
                : widget.level == 'advanced'
                    ? l10n.translate('level_advanced')
                    : l10n.translate('level_initial'),
            style: const TextStyle(
                color: AppColors.orange, fontWeight: FontWeight.w700),
          ),
          if (widget.level == null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: DropdownButtonFormField<String>(
                value: _selectedLevel,
                decoration:
                    InputDecoration(labelText: l10n.translate('choose_level')),
                items: [
                  DropdownMenuItem(
                      value: 'initial',
                      child: Text(l10n.translate('level_initial'))),
                  DropdownMenuItem(
                      value: 'intermediate',
                      child: Text(l10n.translate('level_intermediate'))),
                  DropdownMenuItem(
                      value: 'advanced',
                      child: Text(l10n.translate('level_advanced'))),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _selectedLevel = value);
                },
              ),
            ),
          const SizedBox(height: 20),
          Text(
            l10n.translate('feedback_question'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
          FeedbackRatingBar(
            value: form.rating,
            onChanged: notifier.updateRating,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.translate('feedback_importance'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: notifier.updateComment,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: l10n.translate('feedback_placeholder'),
              filled: true,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),
          OrangeButton(
            label: form.submitting
                ? l10n.translate('loading')
                : l10n.translate('feedback_send'),
            onPressed: form.submitting
                ? null
                : () async {
                    if (form.rating == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              l10n.translate('feedback_rating_required'))));
                      return;
                    }
                    await notifier.submit(
                        exerciseId: widget.exerciseId,
                        level: widget.level ?? _selectedLevel);
                    if (mounted) Navigator.of(context).pop();
                  },
          ),
          if (form.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child:
                  Text(form.error!, style: const TextStyle(color: Colors.red)),
            ),
          if (form.success)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(l10n.translate('feedback_success')),
            ),
        ],
      ),
    );
  }
}
