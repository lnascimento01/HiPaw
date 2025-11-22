import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class FeedbackInfoView extends StatelessWidget {
  const FeedbackInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('feedback'))),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(l10n.translate('feedback_info_body')),
      ),
    );
  }
}
