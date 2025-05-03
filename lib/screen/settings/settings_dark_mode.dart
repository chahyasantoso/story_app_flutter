import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsDarkMode extends StatelessWidget {
  const SettingsDarkMode({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations =
        AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

    return Consumer<SettingsProvider>(
      builder: (context, provider, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(appLocalizations.settingsDarkmode),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Switch(
                value: provider.settings.isDarkModeEnabled,
                onChanged: (value) {
                  provider.setDarkMode(value);
                },
              ),
            )
          ],
        );
      },
    );
  }
}
