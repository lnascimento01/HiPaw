import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/exercise_controller.dart';
import '../../controllers/recent_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/pillar_localization_extension.dart';
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
      ..sort((a, b) => recentState.exerciseIds
          .indexOf(a.id)
          .compareTo(recentState.exerciseIds.indexOf(b.id)));
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        l10n.translate('home_title_hi_paws'),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (recentState.pendingFeedback.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.softLilac.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: AppColors.darkBlue,
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                            color: AppColors.darkBlue,
                                            fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    l10n.translate('pending_feedback_hint'),
                                    style: TextStyle(
                                        color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: l10n.translate('home_search'),
                              filled: true,
                              fillColor: AppColors.softLilac.withOpacity(0.3),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: ref
                                .read(exerciseControllerProvider.notifier)
                                .search,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.darkBlue,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.darkBlue.withOpacity(0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.tune, color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: PsychomotorPillar.values
                            .map(
                              (pillar) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: _FilterPill(
                                  label: pillar.localizedLabel(l10n),
                                  selected: exercisesState.activePillars
                                      .contains(pillar),
                                  onTap: () => ref
                                      .read(exerciseControllerProvider.notifier)
                                      .togglePillar(pillar),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (showRecents) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.translate('recent'),
                              style: Theme.of(context).textTheme.titleMedium),
                          TextButton(
                            onPressed: () {},
                            child: Text(l10n.translate('home_view_all')),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (recents.isEmpty)
                        _EmptyRecents(l10n: l10n)
                      else
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: recents
                              .map(
                                (exercise) => _RecentChip(
                                  label: exercise.title,
                                  onTap: () =>
                                      context.push('/exercise/${exercise.id}'),
                                ),
                              )
                              .toList(),
                        ),
                      const SizedBox(height: 24),
                    ],
                    Text(l10n.translate('exercises'),
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final exercise = exercisesState.filtered[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ExerciseCard(exercise: exercise),
                  );
                },
                childCount: exercisesState.filtered.length,
              ),
            ),
            SliverToBoxAdapter(
                child: SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 16)),
          ],
        ),
      ),
    );
  }
}

class _EmptyRecents extends StatelessWidget {
  const _EmptyRecents({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.softLilac.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.translate('recent_empty'),
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(l10n.translate('recent_empty_hint')),
        ],
      ),
    );
  }
}

class _RecentChip extends StatelessWidget {
  const _RecentChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFDE9D2),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.orange.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.orange,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.darkBlue : const Color(0xFFFDE9D2),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(selected ? 0.2 : 0.05),
              blurRadius: selected ? 14 : 6,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.orange,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
