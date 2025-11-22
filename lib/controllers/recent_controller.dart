import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/exercise.dart';
import '../services/local_storage_service.dart';

class RecentState {
  const RecentState({this.exerciseIds = const [], this.pendingFeedback = const []});

  final List<String> exerciseIds;
  final List<String> pendingFeedback;
}

final recentControllerProvider = StateNotifierProvider<RecentController, RecentState>((ref) {
  return RecentController(ref);
});

class RecentController extends StateNotifier<RecentState> {
  RecentController(this._ref)
      : super(RecentState(
          exerciseIds: _ref.read(localStorageServiceProvider).recentExercises,
          pendingFeedback: _ref.read(localStorageServiceProvider).pendingFeedbacks,
        ));

  final Ref _ref;

  void addRecent(String exerciseId) {
    final storage = _ref.read(localStorageServiceProvider);
    final ids = [...state.exerciseIds];
    ids.remove(exerciseId);
    ids.insert(0, exerciseId);
    final trimmed = ids.take(10).toList();
    storage.setRecentExercises(trimmed);
    state = RecentState(exerciseIds: trimmed, pendingFeedback: state.pendingFeedback);
  }

  void markPendingFeedback(String exerciseId) {
    final storage = _ref.read(localStorageServiceProvider);
    final pending = {...state.pendingFeedback}..add(exerciseId);
    final list = pending.toList();
    storage.setPendingFeedbacks(list);
    state = RecentState(exerciseIds: state.exerciseIds, pendingFeedback: list);
  }

  void clearPendingFeedback(String exerciseId) {
    final storage = _ref.read(localStorageServiceProvider);
    final pending = [...state.pendingFeedback];
    pending.remove(exerciseId);
    storage.setPendingFeedbacks(pending);
    state = RecentState(exerciseIds: state.exerciseIds, pendingFeedback: pending);
  }
}
