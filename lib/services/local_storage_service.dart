import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bootstrap.dart';

class LocalStorageService {
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  String? get languageCode => _prefs.getString('language_code');

  Future<void> setLanguageCode(String code) async => _prefs.setString('language_code', code);

  bool get isVisitor => _prefs.getBool('is_visitor') ?? false;

  Future<void> setVisitor(bool value) async => _prefs.setBool('is_visitor', value);

  List<String> get recentExercises {
    final raw = _prefs.getString('recent_exercises');
    if (raw == null) return [];
    return List<String>.from(jsonDecode(raw) as List<dynamic>);
  }

  Future<void> setRecentExercises(List<String> ids) async => _prefs.setString('recent_exercises', jsonEncode(ids));

  List<String> get pendingFeedbacks {
    final raw = _prefs.getString('pending_feedbacks');
    if (raw == null) return [];
    return List<String>.from(jsonDecode(raw) as List<dynamic>);
  }

  Future<void> setPendingFeedbacks(List<String> ids) async => _prefs.setString('pending_feedbacks', jsonEncode(ids));
}

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageService(prefs);
});
