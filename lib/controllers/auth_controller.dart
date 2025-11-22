import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../repositories/firestore_repository.dart';
import '../services/local_storage_service.dart';

class AuthState {
  const AuthState({this.user, this.isVisitor = false, this.loading = false, this.error});

  final AppUser? user;
  final bool isVisitor;
  final bool loading;
  final String? error;

  bool get isAuthenticated => user != null;
  bool get isAdmin => user?.isAdmin ?? false;
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<AuthState> {
  AuthController(this.ref) : super(const AuthState()) {
    _init();
  }

  final Ref ref;
  StreamSubscription<AppUser?>? _subscription;

  void _init() {
    final repository = ref.read(firestoreRepositoryProvider);
    final storage = ref.read(localStorageServiceProvider);
    final isVisitor = storage.isVisitor;
    if (isVisitor) {
      state = const AuthState(isVisitor: true);
    }
    _subscription = repository.watchAuthenticatedUser().listen((user) {
      state = AuthState(user: user, isVisitor: false);
      storage.setVisitor(false);
    });
  }

  Future<void> login(String email, String password) async {
    try {
      state = AuthState(user: state.user, loading: true, isVisitor: false);
      await ref.read(firestoreRepositoryProvider).signIn(email, password);
      state = AuthState(user: state.user, loading: false, isVisitor: false);
    } catch (e) {
      state = AuthState(user: state.user, loading: false, error: e.toString(), isVisitor: false);
    }
  }

  Future<void> logout() async {
    await ref.read(firestoreRepositoryProvider).signOut();
    await ref.read(localStorageServiceProvider).setVisitor(false);
    state = const AuthState();
  }

  Future<void> loginAsVisitor() async {
    await ref.read(localStorageServiceProvider).setVisitor(true);
    state = const AuthState(isVisitor: true);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
