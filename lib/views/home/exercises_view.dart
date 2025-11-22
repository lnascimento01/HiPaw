import 'package:flutter/material.dart';

import 'home_view.dart';

class ExercisesView extends StatelessWidget {
  const ExercisesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView(showRecents: false);
  }
}
