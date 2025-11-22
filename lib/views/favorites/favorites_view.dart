import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/exercise_controller.dart';
import '../../controllers/favorites_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/exercise_card.dart';

class FavoritesView extends ConsumerWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final favorites = ref.watch(favoritesControllerProvider).favorites;
    final exercises = ref.watch(exerciseControllerProvider).exercises;
    final l10n = AppLocalizations.of(context);
    if (auth.user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.translate('favorites'))),
        body: Center(child: Text(l10n.translate('favorites_only_logged'))),
      );
    }
    final favoriteExercises = exercises.where((exercise) => favorites.any((fav) => fav.exerciseId == exercise.id)).toList();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('favorites'))),
      body: favoriteExercises.isEmpty
          ? Center(child: Text(l10n.translate('no_favorites')))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteExercises.length,
              itemBuilder: (context, index) => ExerciseCard(exercise: favoriteExercises[index]),
            ),
    );
  }
}
