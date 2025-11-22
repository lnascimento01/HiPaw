import 'package:flutter/material.dart';

import '../../features/admin/presentation/views/admin_home_screen.dart';
import '../../features/auth/presentation/views/login_screen.dart';
import '../../features/auth/presentation/views/splash_screen.dart';
import '../../features/patient/presentation/views/patient_home_screen.dart';
import '../constants/app_routes.dart';

class AppRouter {
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case AppRoutes.login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case AppRoutes.adminHome:
        return MaterialPageRoute<void>(
          builder: (_) => const AdminHomeScreen(),
          settings: settings,
        );
      case AppRoutes.patientHome:
        return MaterialPageRoute<void>(
          builder: (_) => const PatientHomeScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
    }
  }
}
