import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/app_user_model.dart';
import '../../../../core/services/user_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    AuthRemoteDataSource? remoteDataSource,
    UserLocalDataSource? localDataSource,
  })  : _remote = remoteDataSource ?? AuthRemoteDataSource(),
        _local = localDataSource ?? UserLocalDataSource();

  final AuthRemoteDataSource _remote;
  final UserLocalDataSource _local;

  @override
  Future<AppUser> register({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final user = await _remote.register(
      email: email,
      password: password,
      role: role,
    );
    await _local.cacheUser(user);
    return user;
  }

  @override
  Future<AppUser> signIn(String email, String password) async {
    final user = await _remote.signIn(email, password);
    await _local.cacheUser(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    await _remote.signOut();
    await _local.clear();
  }

  @override
  Stream<AppUser?> watchUser() async* {
    final cachedUser = await _local.getCachedUser();
    if (cachedUser != null) {
      yield cachedUser;
    }
    yield* _remote.watchUser().map((user) {
      if (user == null) {
        _local.clear();
        return null;
      }
      _local.cacheUser(user as AppUserModel);
      return user;
    });
  }
}
