import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/settings_provider.dart';

class SettingsLocale extends StatelessWidget {
  const SettingsLocale({super.key});

  final supportedLocales = AppLocalizations.supportedLocales;

  @override
  Widget build(BuildContext context) {
    final appLocalizations =
        AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

    return Consumer<SettingsProvider>(
      builder: (context, provider, child) {
        final languageCode = provider.settings.locale.languageCode;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(appLocalizations.settingsLanguage),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: DropdownMenu(
                initialSelection: languageCode,
                leadingIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CountryFlag.fromLanguageCode(
                    languageCode,
                    shape: const Circle(),
                  ),
                ),
                enableFilter: false,
                dropdownMenuEntries: supportedLocales
                    .map(
                      (locale) => DropdownMenuEntry(
                        value: locale.languageCode,
                        label: locale.toString().toUpperCase(),
                        leadingIcon: CountryFlag.fromLanguageCode(
                          locale.languageCode,
                          shape: const Circle(),
                        ),
                      ),
                    )
                    .toList(),
                onSelected: (value) {
                  final locale = Locale(value ?? "en");
                  provider.setLocale(locale);
                },
              ),
            )
          ],
        );
      },
    );
  }
}
