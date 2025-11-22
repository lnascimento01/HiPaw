import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category.dart';

class CategoryService {
  CategoryService(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('categories');

  Stream<List<Category>> watchCategories() => _collection
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Category.fromMap(doc.id, doc.data())).toList());

  Future<void> createCategory({required String name, required CategoryType type}) async {
    final doc = _collection.doc();
    final category = Category(id: doc.id, name: name, type: type, createdAt: DateTime.now());
    await doc.set(category.toMap());
  }

  Future<void> deleteCategory(String id) => _collection.doc(id).delete();
}
