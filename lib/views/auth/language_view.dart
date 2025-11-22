import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/language_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/pattern_background.dart';
import '../../widgets/themed_buttons.dart';

class LanguageView extends ConsumerWidget {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(languageControllerProvider);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: PatternBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 40),
                AppLogo(title: l10n.translate('brand_title'), size: 110),
                const SizedBox(height: 28),
                Text(
                  l10n.translate('language_choose'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.translate('language_dual_title'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                OrangeButton(
                  label: l10n.translate('portuguese').toUpperCase(),
                  onPressed: asyncState.isLoading
                      ? null
                      : () async {
                          await ref
                              .read(languageControllerProvider.notifier)
                              .selectLocale(const Locale('pt', 'BR'));
                          if (context.mounted) context.go('/login');
                        },
                ),
                const SizedBox(height: 14),
                GreenButton(
                  label: l10n.translate('english').toUpperCase(),
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
                  style: TextStyle(
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
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
