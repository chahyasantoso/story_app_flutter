import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

class DescriptionFormField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? errorText;
  final void Function(String value)? onChanged;
  final void Function()? onFocus;

  const DescriptionFormField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.onFocus,
    this.errorText,
  });

  @override
  State<DescriptionFormField> createState() => _DescriptionFormFieldState();
}

class _DescriptionFormFieldState extends State<DescriptionFormField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(() {
      if (widget.focusNode?.hasFocus ?? false) widget.onFocus?.call();
    });
  }

  AppLocalizations get appLocalizations =>
      AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: appLocalizations.descriptionLabelText,
        hintText: appLocalizations.descriptionHintText,
        errorText: widget.errorText,
      ),
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 5,
    );
  }
}
