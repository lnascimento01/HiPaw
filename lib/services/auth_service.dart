import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<UserCredential> signIn(String email, String password) =>
      _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> signOut() => _firebaseAuth.signOut();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> updateEmail(String email) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateEmail(email);
    }
  }

  Future<void> updatePassword(String password) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updatePassword(password);
    }
  }
}
