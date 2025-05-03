import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

class DescriptionFormField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String value)? onChanged;

  const DescriptionFormField(
      {super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final appLocalizations =
        AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: appLocalizations.descriptionLabelText,
        hintText: appLocalizations.descriptionHintText,
      ),
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 5,
      validator: (value) {
        if (value?.isEmpty == true) {
          return appLocalizations.messageDescriptionEmpty;
        }
        return null;
      },
    );
  }
}
