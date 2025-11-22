import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirestoreSchemaService {
  FirestoreSchemaService(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> ensureBaseCollections() async {
    try {
      for (final definition in _definitions) {
        await _ensureCollection(definition);
      }
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        debugPrint('FirestoreSchemaService: skipping schema setup (permission denied).');
        return;
      }
      rethrow;
    }
  }

  Future<void> _ensureCollection(CollectionDefinition definition) async {
    final collection = _firestore.collection(definition.name);
    final hasDocuments = await _collectionHasDocuments(collection);
    if (!hasDocuments) {
      await collection.doc('_example').set(definition.exampleDocument());
    }
    final schemaRef = collection.doc('_schema');
    final schemaDoc = await schemaRef.get();
    if (!schemaDoc.exists) {
      await schemaRef.set({
        'collection': definition.name,
        'documentation': definition.description,
        'fields': definition.fields.map((field) => field.toMap()).toList(),
        'exampleDocument': definition.exampleDocument(),
      });
    }
  }

  Future<bool> _collectionHasDocuments(CollectionReference<Map<String, dynamic>> reference) async {
    final snapshot = await reference.limit(1).get();
    return snapshot.docs.isNotEmpty;
  }
}

class CollectionDefinition {
  const CollectionDefinition({
    required this.name,
    required this.description,
    required this.fields,
    required Map<String, dynamic> Function() exampleBuilder,
  }) : _exampleBuilder = exampleBuilder;

  final String name;
  final String description;
  final List<CollectionFieldDefinition> fields;
  final Map<String, dynamic> Function() _exampleBuilder;

  Map<String, dynamic> exampleDocument() => _exampleBuilder();
}

class CollectionFieldDefinition {
  const CollectionFieldDefinition({
    required this.name,
    required this.type,
    required this.description,
    this.required = true,
  });

  final String name;
  final String type;
  final String description;
  final bool required;

  Map<String, dynamic> toMap() => {
        'name': name,
        'type': type,
        'description': description,
        'required': required,
      };
}

DateTime _defaultDate() => DateTime.utc(2023, 1, 1);

final _definitions = <CollectionDefinition>[
  CollectionDefinition(
    name: 'users',
    description: 'Stores every authenticated account with administrative or patient permissions.',
    fields: const [
      CollectionFieldDefinition(name: 'name', type: 'string', description: 'Full name of the user'),
      CollectionFieldDefinition(name: 'email', type: 'string', description: 'Login email'),
      CollectionFieldDefinition(name: 'role', type: 'string', description: 'admin or patient role'),
      CollectionFieldDefinition(name: 'createdAt', type: 'timestamp', description: 'Creation date'),
      CollectionFieldDefinition(name: 'updatedAt', type: 'timestamp', description: 'Last update date'),
    ],
    exampleBuilder: () => {
      'name': 'Example Admin',
      'email': 'admin@example.com',
      'role': 'admin',
      'createdAt': Timestamp.fromDate(_defaultDate()),
      'updatedAt': Timestamp.fromDate(_defaultDate()),
    },
  ),
  CollectionDefinition(
    name: 'exercises',
    description: 'Therapeutic exercises with descriptions for each level, metadata, and media links.',
    fields: const [
      CollectionFieldDefinition(name: 'name', type: 'string', description: 'Exercise title'),
      CollectionFieldDefinition(name: 'description', type: 'string', description: 'General description'),
      CollectionFieldDefinition(name: 'difficulty', type: 'string', description: 'initial/intermediate/advanced'),
      CollectionFieldDefinition(name: 'categoryId', type: 'string', description: 'Reference to categories collection'),
      CollectionFieldDefinition(name: 'categoryName', type: 'string', description: 'Human readable category'),
      CollectionFieldDefinition(name: 'videoUrl', type: 'string', description: 'Streaming link'),
      CollectionFieldDefinition(name: 'createdAt', type: 'timestamp', description: 'Creation date'),
    ],
    exampleBuilder: () => {
      'name': 'Balance trail',
      'title': 'Balance trail',
      'subtitle': 'Equilíbrio dinâmico com apoio do cão',
      'description': 'Child follows the dog across pillows to improve balance.',
      'difficulty': 'intermediate',
      'categoryId': 'motor-skills',
      'categoryName': 'Motor skills',
      'category': 'Motor skills',
      'pillars': ['motora', 'sensorial'],
      'descriptionInitial': 'Follow the dog slowly using three pillows.',
      'descriptionIntermediate': 'Add zig-zag pillows with visual cues.',
      'descriptionAdvanced': 'Include small jumps and commands.',
      'materialsInitial': ['Three pillows'],
      'materialsIntermediate': ['Five pillows', 'Directional cards'],
      'materialsAdvanced': ['High pillows', 'Short hoop'],
      'stepsInitial': ['Invite the dog to lead the path.'],
      'stepsIntermediate': ['Match the arrows before each step.'],
      'stepsAdvanced': ['Finish with breathing while hugging the dog.'],
      'notesInitial': 'Keep a caregiver nearby.',
      'notesIntermediate': 'Vary pillow order each round.',
      'notesAdvanced': 'Monitor fatigue.',
      'videoUrl': 'https://example.com/video.mp4',
      'createdAt': Timestamp.fromDate(_defaultDate()),
    },
  ),
  CollectionDefinition(
    name: 'favorites',
    description: 'Relationship between patients and their preferred exercises.',
    fields: const [
      CollectionFieldDefinition(name: 'userId', type: 'string', description: 'User reference'),
      CollectionFieldDefinition(name: 'exerciseId', type: 'string', description: 'Exercise reference'),
      CollectionFieldDefinition(name: 'createdAt', type: 'timestamp', description: 'When it was favorited'),
    ],
    exampleBuilder: () => {
      'userId': 'user-example',
      'exerciseId': 'exercise-example',
      'createdAt': Timestamp.fromDate(_defaultDate()),
    },
  ),
  CollectionDefinition(
    name: 'feedbacks',
    description: 'Ratings and qualitative comments for each exercise execution.',
    fields: const [
      CollectionFieldDefinition(name: 'userId', type: 'string', description: 'Author of the feedback'),
      CollectionFieldDefinition(name: 'exerciseId', type: 'string', description: 'Exercise reference'),
      CollectionFieldDefinition(name: 'rating', type: 'number', description: 'Rating between 1 and 5'),
      CollectionFieldDefinition(name: 'comment', type: 'string', description: 'Optional written feedback', required: false),
      CollectionFieldDefinition(name: 'level', type: 'string', description: 'Level practiced'),
      CollectionFieldDefinition(name: 'createdAt', type: 'timestamp', description: 'Submission date'),
    ],
    exampleBuilder: () => {
      'userId': 'user-example',
      'exerciseId': 'exercise-example',
      'rating': 5,
      'comment': 'Great engagement with the dog.',
      'level': 'initial',
      'createdAt': Timestamp.fromDate(_defaultDate()),
    },
  ),
  CollectionDefinition(
    name: 'categories',
    description: 'Exercise categories grouped by therapeutic type.',
    fields: const [
      CollectionFieldDefinition(name: 'name', type: 'string', description: 'Category label'),
      CollectionFieldDefinition(name: 'type', type: 'string', description: 'motor, cognitive, etc.'),
      CollectionFieldDefinition(name: 'createdAt', type: 'timestamp', description: 'Creation date'),
    ],
    exampleBuilder: () => {
      'name': 'Coordenação motora',
      'type': 'motor',
      'createdAt': Timestamp.fromDate(_defaultDate()),
    },
  ),
  CollectionDefinition(
    name: 'levels',
    description: 'Specific textual guidance for each level of an exercise.',
    fields: const [
      CollectionFieldDefinition(name: 'exerciseId', type: 'string', description: 'Exercise reference'),
      CollectionFieldDefinition(name: 'level', type: 'string', description: 'initial/intermediate/advanced'),
      CollectionFieldDefinition(name: 'description', type: 'string', description: 'Narrative for the level'),
    ],
    exampleBuilder: () => {
      'exerciseId': 'exercise-example',
      'level': 'advanced',
      'description': 'Include breathing regulation with the therapy dog.',
    },
  ),
];
