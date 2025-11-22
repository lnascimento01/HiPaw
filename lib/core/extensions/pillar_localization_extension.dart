import '../../l10n/app_localizations.dart';
import '../../models/exercise.dart';

extension PsychomotorPillarLocalization on PsychomotorPillar {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case PsychomotorPillar.cognitiva:
        return l10n.translate('pillar_cognitive');
      case PsychomotorPillar.motora:
        return l10n.translate('pillar_motor');
      case PsychomotorPillar.afetiva:
        return l10n.translate('pillar_affective');
      case PsychomotorPillar.social:
        return l10n.translate('pillar_social');
      case PsychomotorPillar.linguagem:
        return l10n.translate('pillar_language');
      case PsychomotorPillar.sensorial:
        return l10n.translate('pillar_sensory');
    }
  }
}
