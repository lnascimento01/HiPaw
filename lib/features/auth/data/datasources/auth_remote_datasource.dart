import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user_model.dart';
import '../../domain/entities/app_user.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  Future<AppUserModel> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _loadUser(credential.user!);
  }

  Future<AppUserModel> register({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _usersCollection.doc(credential.user!.uid).set({
      'email': email,
      'role': role.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return AppUserModel(
      id: credential.user!.uid,
      email: email,
      role: role,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<AppUserModel?> watchUser() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return _loadUser(user);
    });
  }

  Future<AppUserModel> _loadUser(User user) async {
    final doc = await _usersCollection.doc(user.uid).get();
    if (!doc.exists) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        message: 'Perfil de usuário não encontrado.',
      );
    }
    return AppUserModel.fromFirestore(doc.data()!, id: doc.id);
  }
}
