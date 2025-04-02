import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/routes/auth_router_delegate.dart';
import 'package:story_app/style/colors/story_colors.dart';
import 'package:story_app/style/typography/story_text_styles.dart';
import 'package:story_app/widget/adaptive_header_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({
    super.key,
  });

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdaptiveHeaderLayout(
        headerSize: 0.5,
        headerBackground: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(200),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                AppLocalizations.of(context)!.titleApp,
                style: StoryTextStyles.displayLarge.copyWith(
                  color: StoryColors.green.color,
                ),
              ),
            ),
          ),
        ),
        child: buildContent(),
      ),
    );
  }

  Widget buildContent() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment:
            !isPortrait ? MainAxisAlignment.center : MainAxisAlignment.start,
        spacing: 16,
        children: [
          Text(
            AppLocalizations.of(context)!.landingText,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    context.read<AuthRouterDelegate>().onLogin();
                  },
                  child: Text(AppLocalizations.of(context)!.login),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    context.read<AuthRouterDelegate>().onRegister();
                  },
                  child: Text(AppLocalizations.of(context)!.register),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
