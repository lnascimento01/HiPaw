import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/category.dart';
import '../models/exercise.dart';
import '../repositories/firestore_repository.dart';

class AdminState {
  const AdminState({
    this.userError,
    this.exerciseError,
    this.categoryError,
    this.submittingUser = false,
    this.submittingExercise = false,
    this.submittingCategory = false,
  });

  final String? userError;
  final String? exerciseError;
  final String? categoryError;
  final bool submittingUser;
  final bool submittingExercise;
  final bool submittingCategory;

  AdminState copyWith({
    bool? submittingUser,
    bool? submittingExercise,
    bool? submittingCategory,
    String? userError,
    String? exerciseError,
    String? categoryError,
    bool resetUserError = false,
    bool resetExerciseError = false,
    bool resetCategoryError = false,
  }) =>
      AdminState(
        userError: resetUserError ? null : (userError ?? this.userError),
        exerciseError: resetExerciseError ? null : (exerciseError ?? this.exerciseError),
        categoryError: resetCategoryError ? null : (categoryError ?? this.categoryError),
        submittingUser: submittingUser ?? this.submittingUser,
        submittingExercise: submittingExercise ?? this.submittingExercise,
        submittingCategory: submittingCategory ?? this.submittingCategory,
      );
}

final adminControllerProvider = StateNotifierProvider<AdminController, AdminState>((ref) {
  return AdminController(ref);
});

class AdminController extends StateNotifier<AdminState> {
  AdminController(this._ref) : super(const AdminState());

  final Ref _ref;

  Future<void> createPatient({required String name, required String email, required String password}) async {
    state = state.copyWith(submittingUser: true, resetUserError: true);
    try {
      await _ref.read(firestoreRepositoryProvider).createPatient(name: name, email: email, password: password);
    } catch (e) {
      state = state.copyWith(userError: e.toString());
    } finally {
      state = state.copyWith(submittingUser: false);
    }
  }

  Future<void> createExercise({
    required String title,
    required String subtitle,
    required Set<PsychomotorPillar> pillars,
    required String descriptionInitial,
    required String descriptionIntermediate,
    required String descriptionAdvanced,
    required List<String> materialsInitial,
    required List<String> materialsIntermediate,
    required List<String> materialsAdvanced,
    required List<String> stepsInitial,
    required List<String> stepsIntermediate,
    required List<String> stepsAdvanced,
    required String categoryId,
    required String categoryName,
    required String difficulty,
    String notesInitial = '',
    String notesIntermediate = '',
    String notesAdvanced = '',
    String videoUrl = '',
  }) async {
    state = state.copyWith(submittingExercise: true, resetExerciseError: true);
    try {
      await _ref.read(firestoreRepositoryProvider).createExerciseFromForm(
            title: title,
            subtitle: subtitle,
            pillars: pillars,
            descriptionInitial: descriptionInitial,
            descriptionIntermediate: descriptionIntermediate,
            descriptionAdvanced: descriptionAdvanced,
            materialsInitial: materialsInitial,
            materialsIntermediate: materialsIntermediate,
            materialsAdvanced: materialsAdvanced,
            stepsInitial: stepsInitial,
            stepsIntermediate: stepsIntermediate,
            stepsAdvanced: stepsAdvanced,
            categoryId: categoryId,
            categoryName: categoryName,
            difficulty: difficulty,
            notesInitial: notesInitial,
            notesIntermediate: notesIntermediate,
            notesAdvanced: notesAdvanced,
            videoUrl: videoUrl,
          );
    } catch (e) {
      state = state.copyWith(exerciseError: e.toString());
    } finally {
      state = state.copyWith(submittingExercise: false);
    }
  }

  Future<void> createCategory({required String name, required CategoryType type}) async {
    state = state.copyWith(submittingCategory: true, resetCategoryError: true);
    try {
      await _ref.read(firestoreRepositoryProvider).createCategory(name: name, type: type);
    } catch (e) {
      state = state.copyWith(categoryError: e.toString());
    } finally {
      state = state.copyWith(submittingCategory: false);
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _ref.read(firestoreRepositoryProvider).deleteCategory(id);
    } catch (e) {
      state = state.copyWith(categoryError: e.toString());
    }
  }
}
