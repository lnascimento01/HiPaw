import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/firestore_repository.dart';
import 'auth_controller.dart';
import 'recent_controller.dart';

class FeedbackFormState {
  const FeedbackFormState({this.rating = 0, this.comment = '', this.submitting = false, this.success = false, this.error});

  final int rating;
  final String comment;
  final bool submitting;
  final bool success;
  final String? error;

  FeedbackFormState copyWith({int? rating, String? comment, bool? submitting, bool? success, String? error}) =>
      FeedbackFormState(
        rating: rating ?? this.rating,
        comment: comment ?? this.comment,
        submitting: submitting ?? this.submitting,
        success: success ?? this.success,
        error: error,
      );
}

final feedbackFormControllerProvider = StateNotifierProvider<FeedbackFormController, FeedbackFormState>((ref) {
  return FeedbackFormController(ref);
});

final feedbackStreamProvider = StreamProvider((ref) {
  return ref.watch(firestoreRepositoryProvider).watchFeedbacks();
});

class FeedbackFormController extends StateNotifier<FeedbackFormState> {
  FeedbackFormController(this.ref) : super(const FeedbackFormState());

  final Ref ref;

  void updateRating(int rating) => state = state.copyWith(rating: rating);

  void updateComment(String comment) => state = state.copyWith(comment: comment);

  Future<void> submit({required String exerciseId, required String level}) async {
    final user = ref.read(authControllerProvider).user;
    if (user == null) return;
    try {
      state = state.copyWith(submitting: true, success: false, error: null);
      await ref.read(firestoreRepositoryProvider).submitFeedback(
            userId: user.id,
            exerciseId: exerciseId,
            level: level,
            rating: state.rating,
            comment: state.comment,
          );
      ref.read(recentControllerProvider.notifier).clearPendingFeedback(exerciseId);
      state = state.copyWith(submitting: false, success: true, rating: 0, comment: '');
    } catch (e) {
      state = state.copyWith(submitting: false, success: false, error: e.toString());
    }
  }
}
