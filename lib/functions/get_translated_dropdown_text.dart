import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getTranslatedDropdownText(String value, BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  switch (value) {
    case 'Alle anzeigen':
      return l10n.view_all;
    case 'Tools':
      return l10n.tools;
    case 'Programme':
      return l10n.programs;

    default:
      // As a fallback, return the original value if no match is found
      return value;
  }
}
