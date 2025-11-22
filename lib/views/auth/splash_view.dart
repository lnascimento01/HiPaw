import 'package:flutter/material.dart';

import '../../core/ui/hi_paws_theme.dart';
import '../../core/ui/widgets/hi_paws_pattern_background.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_logo.dart';

/// Displays the branded splash artwork while the app finishes bootstrapping.
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: HiPawsPatternBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeInOut,
                tween: Tween(begin: 0, end: 1),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: child,
                ),
                child: AppLogo(title: l10n.translate('brand_title')),
              ),
              const SizedBox(height: 12),
              Text(l10n.translate('brand_title'), style: HiPawsTextStyles.logo),
            ],
          ),
        ),
      ),
    );
  }
}
