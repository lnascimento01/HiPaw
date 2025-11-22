import 'package:flutter/material.dart';

import '../hi_paws_theme.dart';

class HiPawsSectionTitle extends StatelessWidget {
  const HiPawsSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: HiPawsTextStyles.sectionTitle);
  }
}

class HiPawsOrangeLabel extends StatelessWidget {
  const HiPawsOrangeLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: HiPawsTextStyles.orangeSectionLabel);
  }
}
