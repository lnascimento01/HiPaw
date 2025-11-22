import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/exercise.dart';
import '../models/favorite.dart';
import '../repositories/firestore_repository.dart';
import 'auth_controller.dart';

class FavoritesState {
  const FavoritesState({this.favorites = const []});
  final List<Favorite> favorites;
}

final favoritesControllerProvider = StateNotifierProvider<FavoritesController, FavoritesState>((ref) {
  return FavoritesController(ref);
});

class FavoritesController extends StateNotifier<FavoritesState> {
  FavoritesController(this.ref) : super(const FavoritesState()) {
    ref.listen<AuthState>(authControllerProvider, (_, next) {
      _subscription?.cancel();
      final user = next.user;
      if (user != null) {
        _subscription = ref
            .read(firestoreRepositoryProvider)
            .watchFavorites(user.id)
            .listen((favorites) => state = FavoritesState(favorites: favorites));
      } else {
        state = const FavoritesState();
      }
    }, fireImmediately: true);
  }

  final Ref ref;
  StreamSubscription<List<Favorite>>? _subscription;

  bool isFavorite(String exerciseId) => state.favorites.any((fav) => fav.exerciseId == exerciseId);

  Future<void> toggleFavorite(Exercise exercise) async {
    final user = ref.read(authControllerProvider).user;
    if (user == null) return;
    final exists = isFavorite(exercise.id);
    await ref.read(firestoreRepositoryProvider).toggleFavorite(user.id, exercise.id, exists);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
