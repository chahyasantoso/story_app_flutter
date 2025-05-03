import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  const PasswordFormField({super.key, required this.controller});

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    final appLocalizations =
        AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      decoration: InputDecoration(
        labelText: appLocalizations.passwordLabelText,
        hintText: appLocalizations.passwordHintText,
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return appLocalizations.messagePasswordEmpty;
        }
        if (value.length < 8) {
          return appLocalizations.messagePasswordTooShort;
        }
        return null;
      },
    );
  }
}
