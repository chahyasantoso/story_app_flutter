import 'package:flutter/material.dart';
import 'package:story_app/screen/settings/settings_dark_mode.dart';
import 'package:story_app/screen/settings/settings_locale.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations =
        AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.titleSettings),
      ),
      body: SingleChildScrollView(
        reverse: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  const SettingsDarkMode(),
                  const Divider(),
                  const SettingsLocale(),
                  const Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
