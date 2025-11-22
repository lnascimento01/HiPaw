import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/language_controller.dart';
import '../../l10n/app_localizations.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageControllerProvider);
    final l10n = AppLocalizations.of(context);
    final selectedLocale = language.maybeWhen(data: (value) => value.locale, orElse: () => const Locale('pt', 'BR'));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('settings'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text(l10n.translate('language')),
            trailing: DropdownButton<Locale>(
              value: selectedLocale,
              onChanged: (locale) {
                if (locale != null) {
                  ref.read(languageControllerProvider.notifier).selectLocale(locale);
                }
              },
              items: AppLocalizations.supportedLocales
                  .map((locale) => DropdownMenuItem(
                        value: locale,
                        child: Text(locale.languageCode.toUpperCase()),
                      ))
                  .toList(),
            ),
          ),
          ListTile(
            title: Text(l10n.translate('feedback')),
            subtitle: Text(l10n.translate('settings_feedback_subtitle')),
            onTap: () => context.push('/settings/feedback-info'),
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.translate('about')),
            subtitle: Text(l10n.translate('settings_about_subtitle')),
          ),
        ],
      ),
    );
  }
}
