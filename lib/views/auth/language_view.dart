import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/language_controller.dart';
import '../../core/ui/hi_paws_theme.dart';
import '../../core/ui/widgets/hi_paws_buttons.dart';
import '../../core/ui/widgets/hi_paws_pattern_background.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_logo.dart';

class LanguageView extends ConsumerWidget {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(languageControllerProvider);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: HiPawsPatternBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 40),
                AppLogo(title: l10n.translate('brand_title'), size: 110),
                const SizedBox(height: 28),
                Text(l10n.translate('language_choose'),
                    textAlign: TextAlign.center,
                    style: HiPawsTextStyles.screenTitle),
                const SizedBox(height: 6),
                Text(
                  l10n.translate('language_dual_title'),
                  textAlign: TextAlign.center,
                  style: HiPawsTextStyles.body,
                ),
                const SizedBox(height: 40),
                HiPawsPrimaryButton(
                  label: l10n.translate('portuguese'),
                  onPressed: asyncState.isLoading
                      ? null
                      : () async {
                          await ref
                              .read(languageControllerProvider.notifier)
                              .selectLocale(const Locale('pt', 'BR'));
                          if (context.mounted) context.go('/login');
                        },
                ),
                const SizedBox(height: 16),
                HiPawsSecondaryButton(
                  label: l10n.translate('english'),
                  onPressed: asyncState.isLoading
                      ? null
                      : () async {
                          await ref
                              .read(languageControllerProvider.notifier)
                              .selectLocale(const Locale('en'));
                          if (context.mounted) context.go('/login');
                        },
                ),
                const Spacer(),
                Text(
                  l10n.translate('language_begin_dual'),
                  textAlign: TextAlign.center,
                  style: HiPawsTextStyles.sectionTitle.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
