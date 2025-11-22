import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/exercise.dart';
import '../models/favorite.dart';

class ExerciseService {
  ExerciseService(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('exercises');

  CollectionReference<Map<String, dynamic>> get _favoritesCollection => _firestore.collection('favorites');

  Stream<List<Exercise>> watchExercises() => _collection.orderBy('createdAt', descending: true).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => Exercise.fromMap(doc.id, doc.data())).toList(),
      );

  Future<void> createExercise(Exercise exercise) async => _collection.doc(exercise.id).set(exercise.toMap());

  Future<void> updateExercise(Exercise exercise) async => _collection.doc(exercise.id).update(exercise.toMap());

  Future<Exercise?> fetchExercise(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return Exercise.fromMap(doc.id, doc.data()!);
  }

  Stream<List<Favorite>> watchFavorites(String userId) => _favoritesCollection
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Favorite.fromMap(doc.id, doc.data())).toList());

  Future<void> toggleFavorite(String userId, String exerciseId, bool exists) async {
    if (exists) {
      final snapshot = await _favoritesCollection
          .where('userId', isEqualTo: userId)
          .where('exerciseId', isEqualTo: exerciseId)
          .limit(1)
          .get();
      for (final doc in snapshot.docs) {
        await _favoritesCollection.doc(doc.id).delete();
      }
    } else {
      await _favoritesCollection.add({
        'userId': userId,
        'exerciseId': exerciseId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
