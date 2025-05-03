import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

class UsernameFormField extends StatelessWidget {
  final TextEditingController controller;
  const UsernameFormField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final appLocalizations =
        AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: appLocalizations.usernameLabelText,
        hintText: appLocalizations.usernameHintText,
      ),
      validator: (value) {
        if (value?.isEmpty == true) {
          return appLocalizations.messageUsernameEmpty;
        }
        return null;
      },
    );
  }
}
