import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/app_auth_provider.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/screen/login/login_form.dart';
import 'package:story_app/static/auth_state.dart';
import 'package:story_app/static/snack_bar_utils.dart';
import 'package:story_app/widget/adaptive_header_layout.dart';
import 'package:story_app/widget/story_app_header.dart';
import '/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SnackBarUtils {
  late AppAuthProvider authProvider;
  late AppRoute appRoute;

  void _snackBarListener() {
    final authState = authProvider.authState;
    switch (authState) {
      case AuthError(message: final message):
        showSnackBar(context, message);
      case AuthAuthenticated(message: final message):
        showSnackBar(context, message);
      case AuthAccountCreated():
        showSnackBar(context, appLocalizations.accountCreateSuccess);
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AppAuthProvider>();
    authProvider.addListener(_snackBarListener);
    appRoute = context.read<AppRoute>();
    Future.microtask(() async {
      await authProvider.loaduser();
      if (authProvider.authState is AuthAuthenticated) {
        appRoute.go("/app/home");
      }
    });
  }

  @override
  void dispose() {
    authProvider.removeListener(_snackBarListener);
    super.dispose();
  }

  bool get isPortrait =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  AppLocalizations get appLocalizations =>
      AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(appLocalizations.titleLogin),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Align(
          alignment: isPortrait ? Alignment.topLeft : Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
              children: [
                LoginForm(),
                buildDivider(),
                buildSignInWithGoogle(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Row(
      spacing: 16,
      children: [
        Expanded(child: Divider()),
        Text("OR"),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget buildSignInWithGoogle() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: null,
        child: Text(appLocalizations.signInWithGoogleButtonText),
      ),
    );
  }
}
