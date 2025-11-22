import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'controllers/auth_controller.dart';
import 'controllers/language_controller.dart';
import 'controllers/startup_controller.dart';
import 'views/account/account_view.dart';
import 'views/admin/admin_categories_view.dart';
import 'views/admin/admin_dashboard_view.dart';
import 'views/admin/admin_exercises_view.dart';
import 'views/admin/admin_feedbacks_view.dart';
import 'views/admin/admin_settings_view.dart';
import 'views/admin/admin_users_view.dart';
import 'views/auth/language_view.dart';
import 'views/auth/login_view.dart';
import 'views/auth/splash_view.dart';
import 'views/exercise/exercise_detail_view.dart';
import 'views/exercise/exercise_feedback_view.dart';
import 'views/exercise/exercise_level_view.dart';
import 'views/favorites/favorites_view.dart';
import 'views/home/home_view.dart';
import 'views/home/exercises_view.dart';
import 'views/settings/feedback_info_view.dart';
import 'views/settings/settings_view.dart';
import 'widgets/admin_shell.dart';
import 'widgets/app_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final languageState = ref.watch(languageControllerProvider);
  final startupState = ref.watch(appStartupProvider);
  final authState = ref.watch(authControllerProvider);
  final languageData = languageState.valueOrNull;
  final languageSelected = languageData?.selected ?? false;
  final splashFinished = startupState.hasValue || startupState.hasError;
  final isAdmin = authState.user?.isAdmin ?? false;
  final isLogged = authState.user != null;
  final isVisitor = authState.isVisitor;

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/language',
        name: 'language',
        builder: (context, state) => const LanguageView(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(navigatorKey: _shellNavigatorKey, routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomeView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/exercises',
              name: 'exercises',
              builder: (context, state) => const ExercisesView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/favorites',
              name: 'favorites',
              builder: (context, state) => const FavoritesView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/settings',
              name: 'settings',
              builder: (context, state) => const SettingsView(),
            ),
          ]),
        ],
      ),
      GoRoute(
        path: '/account',
        name: 'account',
        builder: (context, state) => const AccountView(),
      ),
      GoRoute(
        path: '/exercise/:id',
        name: 'exercise-detail',
        builder: (context, state) => ExerciseDetailView(exerciseId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/exercise/:id/level/:level',
        name: 'exercise-level',
        builder: (context, state) => ExerciseLevelView(
          exerciseId: state.pathParameters['id']!,
          level: state.pathParameters['level']!,
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AdminShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/admin/dashboard',
              name: 'admin-dashboard',
              builder: (context, state) => const AdminDashboardView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/admin/exercises',
              name: 'admin-exercises',
              builder: (context, state) => const AdminExercisesView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/admin/users',
              name: 'admin-users',
              builder: (context, state) => const AdminUsersView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/admin/feedbacks',
              name: 'admin-feedbacks',
              builder: (context, state) => const AdminFeedbacksView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/admin/categories',
              name: 'admin-categories',
              builder: (context, state) => const AdminCategoriesView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/admin/settings',
              name: 'admin-settings',
              builder: (context, state) => const AdminSettingsView(),
            ),
          ]),
        ],
      ),
      GoRoute(
        path: '/admin',
        redirect: (context, state) => '/admin/dashboard',
      ),
      GoRoute(
        path: '/exercise/:id/feedback',
        name: 'exercise-feedback',
        builder: (context, state) => ExerciseFeedbackView(
          exerciseId: state.pathParameters['id']!,
          level: state.uri.queryParameters['level'],
        ),
      ),
      GoRoute(
        path: '/settings/feedback-info',
        name: 'feedback-info',
        builder: (context, state) => const FeedbackInfoView(),
      ),
    ],
    redirect: (context, state) {
      final location = state.matchedLocation;
      if (!splashFinished) {
        return location == '/splash' ? null : '/splash';
      }
      if (location == '/splash') {
        if (!languageSelected) return '/language';
        if (isAdmin) return '/admin/dashboard';
        if (isLogged || isVisitor) return '/home';
        return '/login';
      }
      if (!languageSelected && location != '/language') {
        return '/language';
      }
      if (languageSelected && location == '/language') {
        if (isAdmin) return '/admin/dashboard';
        if (isLogged || isVisitor) return '/home';
        return '/login';
      }
      final protectedRoutes = ['/home', '/exercises', '/favorites', '/account', '/settings'];
      final isProtected = protectedRoutes.any((route) => location.startsWith(route));
      if (isProtected && !(isLogged || isVisitor)) {
        return '/login';
      }
      final isAdminRoute = location.startsWith('/admin');
      if (!isAdmin && isAdminRoute) {
        return isLogged || isVisitor ? '/home' : '/login';
      }
      if (isAdmin && protectedRoutes.any((route) => location.startsWith(route))) {
        return '/admin/dashboard';
      }
      if ((isLogged || isVisitor) && location == '/login') {
        return isAdmin ? '/admin/dashboard' : '/home';
      }
      if (location == '/admin') {
        return '/admin/dashboard';
      }
      return null;
    },
  );
});
