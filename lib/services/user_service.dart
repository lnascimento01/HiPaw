import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

class UserService {
  UserService(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('users');

  Future<void> createUser(AppUser user) async {
    await _collection.doc(user.id).set(user.toMap());
  }

  Future<AppUser?> fetchUser(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.id, doc.data()!);
  }

  Stream<AppUser?> watchUser(String id) => _collection.doc(id).snapshots().map((doc) {
        if (!doc.exists) return null;
        return AppUser.fromMap(doc.id, doc.data()!);
      });

  Future<void> updateUser(AppUser user) async => _collection.doc(user.id).update(user.toMap());

  Future<List<AppUser>> fetchAllUsers() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) => AppUser.fromMap(doc.id, doc.data())).toList();
  }

  Stream<List<AppUser>> watchUsers() => _collection.snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => AppUser.fromMap(doc.id, doc.data())).toList(),
      );
}
