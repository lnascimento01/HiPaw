import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_routes.dart';
import '../controllers/auth_controller.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authControllerProvider, (prev, next) {
      if (next.isLoading) return;
      final route = switch (next.user) {
        null => AppRoutes.login,
        final user when user.isAdmin => AppRoutes.adminHome,
        final user when user.isPatient => AppRoutes.patientHome,
        _ => AppRoutes.login,
      };
      Navigator.of(context).pushReplacementNamed(route);
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
