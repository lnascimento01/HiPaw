import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../controllers/admin_data_providers.dart';
import '../../l10n/app_localizations.dart';

class AdminDashboardView extends ConsumerWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final usersMetric = ref.watch(adminUsersProvider).whenData((value) => value.length);
    final exercisesMetric = ref.watch(adminExercisesProvider).whenData((value) => value.length);
    final categoriesMetric = ref.watch(adminCategoriesProvider).whenData((value) => value.length);
    final feedbacks = ref.watch(adminFeedbacksProvider);
    final feedbackMetric = feedbacks.whenData((value) => value.length);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('admin_dashboard'))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l10n.translate('admin_overview_title'), style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(l10n.translate('admin_overview_description')),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _MetricCard(label: l10n.translate('admin_total_patients'), value: usersMetric),
              _MetricCard(label: l10n.translate('admin_total_exercises'), value: exercisesMetric),
              _MetricCard(label: l10n.translate('admin_total_categories'), value: categoriesMetric),
              _MetricCard(label: l10n.translate('admin_total_feedbacks'), value: feedbackMetric),
            ],
          ),
          const SizedBox(height: 32),
          Text(l10n.translate('admin_recent_feedbacks'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          feedbacks.when(
            data: (items) {
              if (items.isEmpty) {
                return Text(l10n.translate('admin_recent_feedbacks_empty'));
              }
              final latest = items.take(4).toList();
              return Column(
                children: latest
                    .map(
                      (feedback) => Card(
                        child: ListTile(
                          leading: CircleAvatar(child: Text('${feedback.rating}★')),
                          title: Text('${l10n.translate('exercise_label')}: ${feedback.exerciseId}'),
                          subtitle: Text('${feedback.level} · ${DateFormat.yMMMd(l10n.locale.toLanguageTag()).format(feedback.createdAt)}'),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())),
            error: (error, stackTrace) => Text(error.toString()),
          ),
          const SizedBox(height: 32),
          Text(l10n.translate('admin_quick_actions'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _QuickActionCard(
            icon: Icons.fitness_center,
            title: l10n.translate('admin_manage_exercises'),
            subtitle: l10n.translate('admin_manage_exercises_hint'),
            onTap: () => context.go('/admin/exercises'),
          ),
          _QuickActionCard(
            icon: Icons.group,
            title: l10n.translate('admin_manage_users'),
            subtitle: l10n.translate('admin_manage_users_hint'),
            onTap: () => context.go('/admin/users'),
          ),
          _QuickActionCard(
            icon: Icons.category,
            title: l10n.translate('admin_manage_categories'),
            subtitle: l10n.translate('admin_manage_categories_hint'),
            onTap: () => context.go('/admin/categories'),
          ),
          _QuickActionCard(
            icon: Icons.reviews,
            title: l10n.translate('admin_manage_feedbacks'),
            subtitle: l10n.translate('admin_manage_feedbacks_hint'),
            onTap: () => context.go('/admin/feedbacks'),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final AsyncValue<int> value;

  @override
  Widget build(BuildContext context) {
    // Force two cards per row by sizing each to roughly half of the available width.
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = 48; // page padding from ListView
    final spacing = 16.0; // Wrap spacing between items
    final available = (width - horizontalPadding) - spacing;
    final itemWidth = (available / 2).clamp(140.0, width);
    return SizedBox(
      width: itemWidth,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: value.when(
            data: (total) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 12),
                Text('$total', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Text(error.toString()),
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
