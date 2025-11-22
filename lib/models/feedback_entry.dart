import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackEntry {
  const FeedbackEntry({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.level,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String exerciseId;
  final String level;
  final int rating;
  final String comment;
  final DateTime createdAt;

  factory FeedbackEntry.fromMap(String id, Map<String, dynamic> data) => FeedbackEntry(
        id: id,
        userId: data['userId'] as String? ?? '',
        exerciseId: data['exerciseId'] as String? ?? '',
        level: data['level'] as String? ?? 'inicial',
        rating: (data['rating'] as num?)?.toInt() ?? 0,
        comment: data['comment'] as String? ?? '',
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'exerciseId': exerciseId,
        'level': level,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt,
      };
}
