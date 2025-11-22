import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../models/category.dart';
import '../models/exercise.dart';
import '../models/favorite.dart';
import '../models/feedback_entry.dart';
import '../services/auth_service.dart';
import '../services/category_service.dart';
import '../services/exercise_service.dart';
import '../services/feedback_service.dart';
import '../services/user_service.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref.watch(firebaseAuthProvider)));
final userServiceProvider = Provider<UserService>((ref) => UserService(ref.watch(firestoreProvider)));
final exerciseServiceProvider = Provider<ExerciseService>((ref) => ExerciseService(ref.watch(firestoreProvider)));
final feedbackServiceProvider = Provider<FeedbackService>((ref) => FeedbackService(ref.watch(firestoreProvider)));
final categoryServiceProvider = Provider<CategoryService>((ref) => CategoryService(ref.watch(firestoreProvider)));

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) => FirestoreRepository(
      authService: ref.watch(authServiceProvider),
      userService: ref.watch(userServiceProvider),
      exerciseService: ref.watch(exerciseServiceProvider),
      feedbackService: ref.watch(feedbackServiceProvider),
      categoryService: ref.watch(categoryServiceProvider),
    ));

class FirestoreRepository {
  FirestoreRepository({
    required this.authService,
    required this.userService,
    required this.exerciseService,
    required this.feedbackService,
    required this.categoryService,
  });

  final AuthService authService;
  final UserService userService;
  final ExerciseService exerciseService;
  final FeedbackService feedbackService;
  final CategoryService categoryService;

  Stream<AppUser?> watchAuthenticatedUser() {
    return authService.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final firestoreUser = await userService.fetchUser(user.uid);
      if (firestoreUser != null) return firestoreUser;
      final newUser = AppUser(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        role: UserRole.patient,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await userService.createUser(newUser);
      return newUser;
    });
  }

  Future<AppUser?> fetchUser(String id) => userService.fetchUser(id);

  Future<void> signIn(String email, String password) => authService.signIn(email, password);

  Future<void> signOut() => authService.signOut();

  Future<void> updateEmail(String email) => authService.updateEmail(email);

  Future<void> updatePassword(String password) => authService.updatePassword(password);

  Stream<List<Exercise>> watchExercises() => exerciseService.watchExercises();

  Future<Exercise?> fetchExercise(String id) => exerciseService.fetchExercise(id);

  Stream<List<Favorite>> watchFavorites(String userId) => exerciseService.watchFavorites(userId);

  Future<void> toggleFavorite(String userId, String exerciseId, bool exists) =>
      exerciseService.toggleFavorite(userId, exerciseId, exists);

  Future<void> createExercise(Exercise exercise) => exerciseService.createExercise(exercise);

  Future<void> updateExercise(Exercise exercise) => exerciseService.updateExercise(exercise);

  Future<void> createPatient({required String name, required String email, required String password}) async {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    final user = AppUser(
      id: credential.user!.uid,
      name: name,
      email: email,
      role: UserRole.patient,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await userService.createUser(user);
  }

  Future<void> createExerciseFromForm({
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
    final doc = FirebaseFirestore.instance.collection('exercises').doc();
    final exercise = Exercise(
      id: doc.id,
      title: title,
      subtitle: subtitle,
      pillars: pillars.toList(),
      descriptionInitial: descriptionInitial,
      descriptionIntermediate: descriptionIntermediate,
      descriptionAdvanced: descriptionAdvanced,
      materialsInitial: materialsInitial,
      materialsIntermediate: materialsIntermediate,
      materialsAdvanced: materialsAdvanced,
      stepsInitial: stepsInitial,
      stepsIntermediate: stepsIntermediate,
      stepsAdvanced: stepsAdvanced,
      notesInitial: notesInitial,
      notesIntermediate: notesIntermediate,
      notesAdvanced: notesAdvanced,
      videoUrl: videoUrl,
      categoryId: categoryId,
      categoryName: categoryName,
      difficulty: difficulty,
      createdAt: DateTime.now(),
    );
    await doc.set(exercise.toMap());
  }

  Future<void> submitFeedback({
    required String userId,
    required String exerciseId,
    required String level,
    required int rating,
    required String comment,
  }) async {
    final feedback = FeedbackEntry(
      id: '',
      userId: userId,
      exerciseId: exerciseId,
      level: level,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );
    await feedbackService.submitFeedback(feedback);
  }

  Stream<List<FeedbackEntry>> watchFeedbacks() => feedbackService.watchFeedbacks();

  Future<List<AppUser>> fetchAllUsers() => userService.fetchAllUsers();

  Stream<List<AppUser>> watchUsers() => userService.watchUsers();

  Stream<List<Category>> watchCategories() => categoryService.watchCategories();

  Future<void> createCategory({required String name, required CategoryType type}) =>
      categoryService.createCategory(name: name, type: type);

  Future<void> deleteCategory(String id) => categoryService.deleteCategory(id);
}
