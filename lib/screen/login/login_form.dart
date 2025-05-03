import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/app_auth_provider.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/static/auth_state.dart';
import 'package:story_app/widget/email_form_field.dart';
import 'package:story_app/widget/loading_button.dart';
import 'package:story_app/widget/password_form_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late AppRoute appRoute;
  late AppAuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    appRoute = context.read<AppRoute>();
    authProvider = context.read<AppAuthProvider>();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticating =
        context.watch<AppAuthProvider>().authState is AuthAuthenticating;
    final appLocalizations =
        AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

    return Form(
      key: formKey,
      child: Column(
        spacing: 8,
        children: [
          EmailFormField(controller: emailController),
          PasswordFormField(controller: passwordController),
          SizedBox(
            height: 4,
          ),
          SizedBox(
            width: double.infinity,
            child: LoadingButton(
              isLoading: isAuthenticating,
              onPressed: onLogin,
              child: Text(appLocalizations.loginButtonText),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              Text(appLocalizations.registerHaveNoAccount),
              ElevatedButton(
                onPressed: isAuthenticating ? null : onRegister,
                child: Text(appLocalizations.registerButtonText),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onLogin() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) return;
    await authProvider.loginUser(
      emailController.text,
      passwordController.text,
    );
    if (authProvider.authState is AuthAuthenticated) {
      appRoute.go("/app/home");
    }
  }

  void onRegister() {
    appRoute.go("/register");
  }
}
