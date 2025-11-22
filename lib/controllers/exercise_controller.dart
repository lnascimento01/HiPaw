import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/exercise.dart';
import '../repositories/firestore_repository.dart';

class ExerciseState {
  const ExerciseState({
    this.exercises = const [],
    this.query = '',
    this.activePillars = const {},
    this.levelFilter = 'all',
  });

  final List<Exercise> exercises;
  final String query;
  final Set<PsychomotorPillar> activePillars;
  final String levelFilter;

  List<Exercise> get filtered {
    return exercises.where((exercise) {
      final matchesQuery = query.isEmpty || exercise.title.toLowerCase().contains(query.toLowerCase());
      final matchesPillar =
          activePillars.isEmpty || exercise.pillars.any((pillar) => activePillars.contains(pillar));
      final matchesLevel = levelFilter == 'all' || _matchesLevelFilter(exercise);
      return matchesQuery && matchesPillar && matchesLevel;
    }).toList();
  }

  bool _matchesLevelFilter(Exercise exercise) {
    switch (levelFilter) {
      case 'initial':
        return exercise.descriptionInitial.isNotEmpty || exercise.stepsInitial.isNotEmpty;
      case 'intermediate':
        return exercise.descriptionIntermediate.isNotEmpty || exercise.stepsIntermediate.isNotEmpty;
      case 'advanced':
        return exercise.descriptionAdvanced.isNotEmpty || exercise.stepsAdvanced.isNotEmpty;
      default:
        return true;
    }
  }

  ExerciseState copyWith({
    List<Exercise>? exercises,
    String? query,
    Set<PsychomotorPillar>? activePillars,
    String? levelFilter,
  }) =>
      ExerciseState(
        exercises: exercises ?? this.exercises,
        query: query ?? this.query,
        activePillars: activePillars ?? this.activePillars,
        levelFilter: levelFilter ?? this.levelFilter,
      );
}

final exerciseControllerProvider = StateNotifierProvider<ExerciseController, ExerciseState>((ref) {
  return ExerciseController(ref);
});

class ExerciseController extends StateNotifier<ExerciseState> {
  ExerciseController(this._ref) : super(const ExerciseState()) {
    _subscription = _ref.read(firestoreRepositoryProvider).watchExercises().listen((exercises) {
      state = state.copyWith(exercises: exercises);
    });
  }

  final Ref _ref;
  StreamSubscription<List<Exercise>>? _subscription;

  void search(String value) => state = state.copyWith(query: value);

  void togglePillar(PsychomotorPillar pillar) {
    final next = Set<PsychomotorPillar>.from(state.activePillars);
    if (next.contains(pillar)) {
      next.remove(pillar);
    } else {
      next.add(pillar);
    }
    state = state.copyWith(activePillars: next);
  }

  void setLevelFilter(String value) => state = state.copyWith(levelFilter: value);

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
