import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

class DescriptionFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? errorText;
  final void Function(String value)? onChanged;

  const DescriptionFormField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final appLocalizations =
        AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: appLocalizations.descriptionLabelText,
        hintText: appLocalizations.descriptionHintText,
        errorText: errorText,
      ),
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 5,
    );
  }
}
