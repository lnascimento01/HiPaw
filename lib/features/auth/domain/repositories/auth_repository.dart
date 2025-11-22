import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<AppUser> signIn(String email, String password);
  Future<AppUser> register({
    required String email,
    required String password,
    required UserRole role,
  });
  Future<void> signOut();
  Stream<AppUser?> watchUser();
}
