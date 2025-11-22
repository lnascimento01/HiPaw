import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/local_storage_service.dart';

class LanguageState {
  final Locale locale;
  final bool selected;

  const LanguageState({required this.locale, required this.selected});

  LanguageState copyWith({Locale? locale, bool? selected}) =>
      LanguageState(locale: locale ?? this.locale, selected: selected ?? this.selected);
}

final languageControllerProvider = AsyncNotifierProvider<LanguageController, LanguageState>(() => LanguageController());

class LanguageController extends AsyncNotifier<LanguageState> {
  @override
  Future<LanguageState> build() async {
    final storage = ref.read(localStorageServiceProvider);
    final code = storage.languageCode;
    final locale = _localeFromCode(code);
    return LanguageState(locale: locale, selected: code != null);
  }

  void previewLocale(Locale locale) {
    final current = state.valueOrNull;
    state = AsyncValue.data(LanguageState(locale: locale, selected: current?.selected ?? false));
  }

  Future<void> selectLocale(Locale locale) async {
    state = const AsyncValue.loading();
    final storage = ref.read(localStorageServiceProvider);
    await storage.setLanguageCode(locale.languageCode);
    state = AsyncValue.data(LanguageState(locale: locale, selected: true));
  }

  Locale _localeFromCode(String? code) {
    switch (code) {
      case 'en':
        return const Locale('en');
      case 'pt':
      case 'pt_BR':
      default:
        return const Locale('pt', 'BR');
    }
  }
}
