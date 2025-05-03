import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

class EmailFormField extends StatelessWidget {
  final TextEditingController controller;
  const EmailFormField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final appLocalizations =
        AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: appLocalizations.emailLabelText,
        hintText: appLocalizations.emailHintText,
      ),
      validator: (value) {
        if (value?.isEmpty == true) {
          return appLocalizations.messageEmailEmpty;
        }
        return null;
      },
    );
  }
}
