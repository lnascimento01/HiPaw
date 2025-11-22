import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  const Favorite({required this.id, required this.userId, required this.exerciseId, required this.createdAt});

  final String id;
  final String userId;
  final String exerciseId;
  final DateTime createdAt;

  factory Favorite.fromMap(String id, Map<String, dynamic> data) => Favorite(
        id: id,
        userId: data['userId'] as String? ?? '',
        exerciseId: data['exerciseId'] as String? ?? '',
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'exerciseId': exerciseId,
        'createdAt': createdAt,
      };
}
