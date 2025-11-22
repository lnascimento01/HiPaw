import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../models/category.dart';
import '../models/exercise.dart';
import '../models/feedback_entry.dart';
import '../repositories/firestore_repository.dart';

final adminUsersProvider = StreamProvider<List<AppUser>>(
  (ref) => ref.watch(firestoreRepositoryProvider).watchUsers(),
);

final adminExercisesProvider = StreamProvider<List<Exercise>>(
  (ref) => ref.watch(firestoreRepositoryProvider).watchExercises(),
);

final adminCategoriesProvider = StreamProvider<List<Category>>(
  (ref) => ref.watch(firestoreRepositoryProvider).watchCategories(),
);

final adminFeedbacksProvider = StreamProvider<List<FeedbackEntry>>(
  (ref) => ref.watch(firestoreRepositoryProvider).watchFeedbacks(),
);
