import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'language_controller.dart';

/// Coordinates the minimum time the splash screen must stay visible.
final appStartupProvider = FutureProvider<void>((ref) async {
  await ref.watch(languageControllerProvider.future);
  await Future<void>.delayed(const Duration(milliseconds: 900));
});
