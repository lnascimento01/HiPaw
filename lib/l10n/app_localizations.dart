import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  const AppLocalizations._(this.locale, this._localizedStrings);

  final Locale locale;
  final Map<String, String> _localizedStrings;

  static const supportedLocales = [Locale('pt', 'BR'), Locale('en')];

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static Future<AppLocalizations> load(Locale locale) async {
    final languageCode = supportedLocales.any((element) => element.languageCode == locale.languageCode)
        ? locale.languageCode
        : 'en';
    final raw = await rootBundle.loadString('lib/l10n/app_${languageCode}.arb');
    final Map<String, dynamic> decoded = jsonDecode(raw) as Map<String, dynamic>;
    final localizedStrings = <String, String>{};
    decoded.forEach((key, value) {
      if (!key.startsWith('@')) {
        localizedStrings[key] = value.toString();
      }
    });
    return AppLocalizations._(locale, localizedStrings);
  }

  String translate(String key) => _localizedStrings[key] ?? key;

  static AppLocalizations of(BuildContext context) => Localizations.of<AppLocalizations>(context, AppLocalizations)!;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any((element) => element.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
