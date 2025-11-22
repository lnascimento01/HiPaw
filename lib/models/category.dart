import 'package:cloud_firestore/cloud_firestore.dart';

enum CategoryType { motor, cognitive, affective, social, language, sensory, other }

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String name;
  final CategoryType type;
  final DateTime createdAt;

  factory Category.fromMap(String id, Map<String, dynamic> data) => Category(
        id: id,
        name: data['name'] as String? ?? '',
        type: CategoryType.values.firstWhere(
          (element) => element.name == (data['type'] as String? ?? 'other'),
          orElse: () => CategoryType.other,
        ),
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'type': type.name,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
