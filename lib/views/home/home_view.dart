import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/exercise_controller.dart';
import '../../controllers/recent_controller.dart';
import '../../core/extensions/pillar_localization_extension.dart';
import '../../core/ui/hi_paws_theme.dart';
import '../../core/ui/widgets/hi_paws_chip.dart';
import '../../l10n/app_localizations.dart';
import '../../models/exercise.dart';
import '../../widgets/exercise_card.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key, this.showRecents = true});

  final bool showRecents;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesState = ref.watch(exerciseControllerProvider);
    final recentState = ref.watch(recentControllerProvider);
    final l10n = AppLocalizations.of(context);
    final recents = exercisesState.exercises
        .where((exercise) => recentState.exerciseIds.contains(exercise.id))
        .toList()
      ..sort(
        (a, b) => recentState.exerciseIds
            .indexOf(a.id)
            .compareTo(recentState.exerciseIds.indexOf(b.id)),
      );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.translate('home_title_hi_paws'),
          style: HiPawsTextStyles.screenTitle,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: HiPawsSpacing.defaultHorizontal,
            vertical: HiPawsSpacing.defaultVertical,
          ),
          children: [
            if (recentState.pendingFeedback.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: HiPawsColors.chipBackground,
                  borderRadius:
                      BorderRadius.circular(HiPawsSpacing.cardBorderRadius),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: HiPawsColors.primaryNavy,
                      foregroundColor: Colors.white,
                      child: Icon(Icons.feedback_outlined),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.translate('pending_feedback'),
                            style: HiPawsTextStyles.sectionTitle.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            l10n.translate('pending_feedback_hint'),
                            style: HiPawsTextStyles.body,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (showRecents) ...[
              const SizedBox(height: 24),
              _RecentSection(
                l10n: l10n,
                recents: recents,
                onChipTap: (exercise) =>
                    context.push('/exercise/${exercise.id}'),
              ),
            ],
            const SizedBox(height: 24),
            _SearchBar(
              hint: l10n.translate('home_search'),
              onChanged: ref.read(exerciseControllerProvider.notifier).search,
            ),
            const SizedBox(height: 20),
            _PillarsFilter(
              l10n: l10n,
              selected: exercisesState.activePillars,
              onToggle:
                  ref.read(exerciseControllerProvider.notifier).togglePillar,
            ),
            const SizedBox(height: 24),
            Text(l10n.translate('exercises'),
                style: HiPawsTextStyles.sectionTitle),
            const SizedBox(height: 16),
            ...exercisesState.filtered.map(
              (exercise) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ExerciseCard(exercise: exercise),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentSection extends StatelessWidget {
  const _RecentSection({
    required this.l10n,
    required this.recents,
    required this.onChipTap,
  });

  final AppLocalizations l10n;
  final List<Exercise> recents;
  final ValueChanged<Exercise> onChipTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.translate('recent'),
                style: HiPawsTextStyles.sectionTitle),
            TextButton(
              onPressed: () {},
              child: Text(
                l10n.translate('home_view_all'),
                style: HiPawsTextStyles.smallLink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (recents.isEmpty)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: HiPawsColors.chipBackground,
              borderRadius:
                  BorderRadius.circular(HiPawsSpacing.cardBorderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.translate('recent_empty'),
                  style: HiPawsTextStyles.sectionTitle.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(l10n.translate('recent_empty_hint'),
                    style: HiPawsTextStyles.body),
              ],
            ),
          )
        else
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                final exercise = recents[index];
                return HiPawsChip(
                  label: exercise.title,
                  onTap: () => onChipTap(exercise),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: recents.length,
            ),
          ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.hint, required this.onChanged});

  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(HiPawsSpacing.cardBorderRadius),
        border: Border.all(color: HiPawsColors.fieldBorder),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _PillarsFilter extends StatelessWidget {
  const _PillarsFilter({
    required this.l10n,
    required this.selected,
    required this.onToggle,
  });

  final AppLocalizations l10n;
  final Set<PsychomotorPillar> selected;
  final void Function(PsychomotorPillar) onToggle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: PsychomotorPillar.values
            .map(
              (pillar) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => onToggle(pillar),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected.contains(pillar)
                          ? HiPawsColors.primaryNavy
                          : HiPawsColors.chipBackground,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      pillar.localizedLabel(l10n),
                      style: HiPawsTextStyles.chip.copyWith(
                        color: selected.contains(pillar)
                            ? Colors.white
                            : HiPawsColors.primaryNavy,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
