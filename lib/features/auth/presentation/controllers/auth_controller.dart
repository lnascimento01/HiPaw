import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/watch_user_usecase.dart';

class AuthState {
  const AuthState({
    this.user,
    this.error,
    this.isLoading = false,
  });

  final AppUser? user;
  final String? error;
  final bool isLoading;

  AuthState copyWith({
    AppUser? user,
    String? error,
    bool? isLoading,
  }) {
    return AuthState(
      user: user ?? this.user,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.read(authRepositoryProvider));
});

class AuthController extends StateNotifier<AuthState> {
  AuthController(AuthRepository repository)
      : _login = LoginUseCase(repository),
        _register = RegisterUseCase(repository),
        _signOut = SignOutUseCase(repository),
        _watchUser = WatchUserUseCase(repository),
        super(const AuthState()) {
    _watchUser().listen((user) {
      state = state.copyWith(user: user, error: null, isLoading: false);
    });
  }

  final LoginUseCase _login;
  final RegisterUseCase _register;
  final SignOutUseCase _signOut;
  final WatchUserUseCase _watchUser;

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _login(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } catch (error) {
      state = state.copyWith(error: error.toString(), isLoading: false);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _register(email: email, password: password, role: role);
      state = state.copyWith(user: user, isLoading: false);
    } catch (error) {
      state = state.copyWith(error: error.toString(), isLoading: false);
    }
  }

  Future<void> signOut() async {
    await _signOut();
    state = state.copyWith(user: null);
  }
}
