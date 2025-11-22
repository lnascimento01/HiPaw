import '../../l10n/app_localizations.dart';
import '../../models/category.dart';

extension CategoryTypeLocalization on CategoryType {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case CategoryType.motor:
        return l10n.translate('pillar_motor');
      case CategoryType.cognitive:
        return l10n.translate('pillar_cognitive');
      case CategoryType.affective:
        return l10n.translate('pillar_affective');
      case CategoryType.social:
        return l10n.translate('pillar_social');
      case CategoryType.language:
        return l10n.translate('pillar_language');
      case CategoryType.sensory:
        return l10n.translate('pillar_sensory');
      case CategoryType.other:
        return l10n.translate('category_type_other');
    }
  }
}
