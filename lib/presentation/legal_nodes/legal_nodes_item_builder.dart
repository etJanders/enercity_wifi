import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/ui/legal_notes/model_legal_notes.dart';

enum LegalNodesIdentifier { termsAndConditions, privacyPolicy }

class LegalNodesItems {
  late final AppLocalizations local;

  LegalNodesItems({required BuildContext context}) {
    local = AppLocalizations.of(context)!;
  }

  List<ModelLegalNodesPage> buildLegalNodesItems() {
    List<ModelLegalNodesPage> items = [
      ModelLegalNodesPage(
          title: local.termsAndConditions,
          itemIdentifier: LegalNodesIdentifier.termsAndConditions),
      ModelLegalNodesPage(
          title: local.privacyPolicy,
          itemIdentifier: LegalNodesIdentifier.privacyPolicy)
    ];
    return items;
  }
}
