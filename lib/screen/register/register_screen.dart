import 'package:flutter/material.dart';
import 'package:story_app/screen/register/register_form.dart';
import 'package:story_app/widget/adaptive_header_layout.dart';
import 'package:story_app/widget/story_app_header.dart';
import '/l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool get isPortrait =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: AdaptiveHeaderLayout(
        headerSize: 0.4,
        headerBackground: StoryAppHeader(),
        child: buildContent(),
      ),
    );
  }

  Widget buildContent() {
    final appLocalizations =
        AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(appLocalizations.titleRegister),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Align(
          alignment: isPortrait ? Alignment.topLeft : Alignment.center,
          child: SingleChildScrollView(
            child: RegisterForm(),
          ),
        ),
      ),
    );
  }
}
