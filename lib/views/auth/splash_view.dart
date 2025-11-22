import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/pattern_background.dart';

/// Displays the branded splash artwork while the app finishes bootstrapping.
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: PatternBackground(
        child: Center(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOut,
            tween: Tween(begin: 0, end: 1),
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: child,
            ),
            child: AppLogo(title: l10n.translate('brand_title')),
          ),
        ),
      ),
    );
  }
}
