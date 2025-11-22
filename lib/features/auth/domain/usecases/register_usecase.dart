import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<AppUser> call({
    required String email,
    required String password,
    required UserRole role,
  }) {
    return _repository.register(
      email: email,
      password: password,
      role: role,
    );
  }
}
