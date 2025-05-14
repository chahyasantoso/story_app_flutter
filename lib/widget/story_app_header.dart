import 'package:flutter/material.dart';
import 'package:story_app/static/flavor_type.dart';
import 'package:story_app/style/typography/story_text_styles.dart';
import '/l10n/app_localizations.dart';

class StoryAppHeader extends StatelessWidget {
  const StoryAppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations =
        AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(FlavorConfig.instance.assetBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: FlavorConfig.instance.storyColor.color.withAlpha(200),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 80,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/background.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  Text(
                    appLocalizations.titleApp,
                    style: StoryTextStyles.displayMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    appLocalizations.landingText,
                    textAlign: TextAlign.center,
                    style: StoryTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
