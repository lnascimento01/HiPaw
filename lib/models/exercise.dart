import 'package:cloud_firestore/cloud_firestore.dart';

enum PsychomotorPillar { cognitiva, motora, afetiva, social, linguagem, sensorial }

class Exercise {
  const Exercise({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.pillars,
    required this.descriptionInitial,
    required this.descriptionIntermediate,
    required this.descriptionAdvanced,
    required this.materialsInitial,
    required this.materialsIntermediate,
    required this.materialsAdvanced,
    required this.stepsInitial,
    required this.stepsIntermediate,
    required this.stepsAdvanced,
    required this.notesInitial,
    required this.notesIntermediate,
    required this.notesAdvanced,
    required this.videoUrl,
    required this.categoryId,
    required this.categoryName,
    required this.difficulty,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<PsychomotorPillar> pillars;
  final String descriptionInitial;
  final String descriptionIntermediate;
  final String descriptionAdvanced;
  final List<String> materialsInitial;
  final List<String> materialsIntermediate;
  final List<String> materialsAdvanced;
  final List<String> stepsInitial;
  final List<String> stepsIntermediate;
  final List<String> stepsAdvanced;
  final String notesInitial;
  final String notesIntermediate;
  final String notesAdvanced;
  final String videoUrl;
  final String categoryId;
  final String categoryName;
  final String difficulty;
  final DateTime createdAt;

  List<String> get levels => const ['inicial', 'intermediário', 'avançado'];

  factory Exercise.fromMap(String id, Map<String, dynamic> data) {
    return Exercise(
      id: id,
      title: data['title'] as String? ?? data['name'] as String? ?? '',
      subtitle: data['subtitle'] as String? ?? '',
      pillars: _mapPillars(data['pillars'] as List<dynamic>?, data['pillar'] as String?),
      descriptionInitial: data['descriptionInitial'] as String? ?? '',
      descriptionIntermediate: data['descriptionIntermediate'] as String? ?? '',
      descriptionAdvanced: data['descriptionAdvanced'] as String? ?? '',
      materialsInitial: _mapStringList(data['materialsInitial']),
      materialsIntermediate: _mapStringList(data['materialsIntermediate']),
      materialsAdvanced: _mapStringList(data['materialsAdvanced']),
      stepsInitial: _mapStringList(data['stepsInitial'], fallback: data['descriptionInitial'] as String?),
      stepsIntermediate:
          _mapStringList(data['stepsIntermediate'], fallback: data['descriptionIntermediate'] as String?),
      stepsAdvanced: _mapStringList(data['stepsAdvanced'], fallback: data['descriptionAdvanced'] as String?),
      notesInitial: data['notesInitial'] as String? ?? '',
      notesIntermediate: data['notesIntermediate'] as String? ?? '',
      notesAdvanced: data['notesAdvanced'] as String? ?? '',
      videoUrl: data['videoUrl'] as String? ?? '',
      categoryId: data['categoryId'] as String? ?? data['category'] as String? ?? '',
      categoryName: data['categoryName'] as String? ?? data['category'] as String? ?? '',
      difficulty: data['difficulty'] as String? ?? 'custom',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'exerciseId': id,
        'name': title,
        'description': descriptionInitial,
        'difficulty': difficulty,
        'categoryId': categoryId,
        'categoryName': categoryName,
        'category': categoryName,
        'title': title,
        'subtitle': subtitle,
        'pillars': pillars.map((p) => p.name).toList(),
        'levels': levels,
        'descriptionInitial': descriptionInitial,
        'descriptionIntermediate': descriptionIntermediate,
        'descriptionAdvanced': descriptionAdvanced,
        'materialsInitial': materialsInitial,
        'materialsIntermediate': materialsIntermediate,
        'materialsAdvanced': materialsAdvanced,
        'stepsInitial': stepsInitial,
        'stepsIntermediate': stepsIntermediate,
        'stepsAdvanced': stepsAdvanced,
        'notesInitial': notesInitial,
        'notesIntermediate': notesIntermediate,
        'notesAdvanced': notesAdvanced,
        'videoUrl': videoUrl,
        'createdAt': createdAt,
      };

  static List<PsychomotorPillar> _mapPillars(List<dynamic>? rawList, String? fallback) {
    if (rawList != null && rawList.isNotEmpty) {
      return rawList
          .map((value) => PsychomotorPillar.values.firstWhere(
                (pillar) => pillar.name == value,
                orElse: () => PsychomotorPillar.motora,
              ))
          .toList();
    }
    if (fallback != null) {
      return [
        PsychomotorPillar.values.firstWhere(
          (pillar) => pillar.name == fallback,
          orElse: () => PsychomotorPillar.motora,
        )
      ];
    }
    return const [PsychomotorPillar.motora];
  }

  static List<String> _mapStringList(dynamic data, {String? fallback}) {
    if (data is List) {
      return data.map((item) => item.toString()).where((item) => item.isNotEmpty).toList();
    }
    if (fallback != null && fallback.isNotEmpty) {
      return fallback
          .split(RegExp(r'[\n\r]+'))
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();
    }
    return const [];
  }
}
