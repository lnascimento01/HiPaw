import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<AppUser> call(String email, String password) {
    return _repository.signIn(email, password);
  }
}
