import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Serviço de autenticação integrado ao Firestore.
class UserService {
  UserService({
    FirebaseAuth? auth,
    FirebaseFirestore? db,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _db = db ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  // -------------------------------
  // REGISTRAR USUÁRIO
  // -------------------------------
  Future<User?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Cria o usuário no Auth
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) return null;

    // Salva no Firestore
    await _db.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': name,
      'email': email,
      'role': 'patient', // padrão, pode mudar
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return user;
  }

  // -------------------------------
  // LOGIN
  // -------------------------------
  Future<User?> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  // -------------------------------
  // LOGOUT
  // -------------------------------
  Future<void> logout() async {
    await _auth.signOut();
  }

  // -------------------------------
  // RECUPERAR SENHA
  // -------------------------------
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // -------------------------------
  // PEGAR DADOS DO USUÁRIO LOGADO
  // -------------------------------
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final snap = await _db.collection('users').doc(uid).get();
    return snap.data();
  }

  // -------------------------------
  // ATUALIZAR DADOS DO USUÁRIO
  // -------------------------------
  Future<void> updateUserData(Map<String, dynamic> data) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    data['updatedAt'] = FieldValue.serverTimestamp();
    await _db.collection('users').doc(uid).update(data);
  }
}
