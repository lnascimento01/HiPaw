import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/feedback_entry.dart';

class FeedbackService {
  FeedbackService(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('feedback');

  Future<void> submitFeedback(FeedbackEntry feedback) async {
    await _collection.add(feedback.toMap());
  }

  Stream<List<FeedbackEntry>> watchFeedbacks() => _collection.orderBy('createdAt', descending: true).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => FeedbackEntry.fromMap(doc.id, doc.data())).toList(),
      );
}
