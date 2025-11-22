import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class WatchUserUseCase {
  const WatchUserUseCase(this._repository);

  final AuthRepository _repository;

  Stream<AppUser?> call() => _repository.watchUser();
}
