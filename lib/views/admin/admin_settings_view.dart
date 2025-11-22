import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/language_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../l10n/app_localizations.dart';

class AdminSettingsView extends ConsumerWidget {
  const AdminSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final language = ref.watch(languageControllerProvider);
    final themeMode = ref.watch(themeControllerProvider);
    final selectedLocale = language.maybeWhen(data: (value) => value.locale, orElse: () => const Locale('pt', 'BR'));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('admin_settings'))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l10n.translate('admin_settings_description')),
          const SizedBox(height: 16),
          ListTile(
            title: Text(l10n.translate('language')),
            subtitle: Text(l10n.translate('language_setting_hint')),
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
          const Divider(),
          SwitchListTile(
            title: Text(l10n.translate('dark_mode')),
            subtitle: Text(l10n.translate('theme_hint')),
            value: themeMode == ThemeMode.dark,
            onChanged: (value) => ref.read(themeControllerProvider.notifier).state = value ? ThemeMode.dark : ThemeMode.light,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.translate('sign_out')),
            subtitle: Text(l10n.translate('admin_sign_out_hint')),
            onTap: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
    );
  }
}
