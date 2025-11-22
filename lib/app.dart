import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_router.dart';
import 'controllers/language_controller.dart';
import 'controllers/theme_controller.dart';
import 'core/ui/hi_paws_theme.dart';
import 'l10n/app_localizations.dart';
import 'services/messaging_service.dart';

class HiPawApp extends ConsumerWidget {
  const HiPawApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeControllerProvider);
    ref.watch(messagingInitializationProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) =>
          AppLocalizations.of(context).translate('app_title'),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: HiPawsColors.background,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: const ColorScheme.light(
          primary: HiPawsColors.primaryOrange,
          onPrimary: Colors.white,
          secondary: HiPawsColors.primaryNavy,
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: HiPawsColors.primaryNavy,
          background: HiPawsColors.background,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: HiPawsColors.primaryNavy,
          titleTextStyle: TextStyle(
            color: HiPawsColors.primaryNavy,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ref.watch(languageControllerProvider).maybeWhen(
            data: (state) => state.locale,
            orElse: () => const Locale('pt', 'BR'),
          ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
