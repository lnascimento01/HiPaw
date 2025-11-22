import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../controllers/admin_data_providers.dart';
import '../../l10n/app_localizations.dart';

class AdminFeedbacksView extends ConsumerWidget {
  const AdminFeedbacksView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final feedbacksAsync = ref.watch(adminFeedbacksProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('admin_feedbacks'))),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: feedbacksAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return Center(child: Text(l10n.translate('admin_recent_feedbacks_empty')));
            }
            return ListView.separated(
              itemBuilder: (context, index) {
                final feedback = items[index];
                final dateLabel = DateFormat.yMMMd(l10n.locale.toLanguageTag()).format(feedback.createdAt);
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${feedback.rating}★')),
                    title: Text('${l10n.translate('exercise_label')}: ${feedback.exerciseId}'),
                    subtitle: Text('${feedback.comment}\n${feedback.level.toUpperCase()} · $dateLabel'),
                    isThreeLine: true,
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: items.length,
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }
}
