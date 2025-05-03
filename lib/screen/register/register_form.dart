import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/app_auth_provider.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/static/auth_state.dart';
import 'package:story_app/widget/email_form_field.dart';
import 'package:story_app/widget/loading_button.dart';
import 'package:story_app/widget/password_form_field.dart';
import 'package:story_app/widget/username_form_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
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
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onRegister() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) return;
    await authProvider.registerUser(
      usernameController.text,
      emailController.text,
      passwordController.text,
    );
    if (authProvider.authState is AuthAccountCreated) {
      appRoute.go("/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCreatingAccount =
        context.watch<AppAuthProvider>().authState is AuthCreatingAccount;
    final appLocalizations =
        AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

    return Form(
      key: formKey,
      child: Column(
        spacing: 8,
        children: [
          UsernameFormField(controller: usernameController),
          EmailFormField(controller: emailController),
          PasswordFormField(controller: passwordController),
          SizedBox(
            height: 4,
          ),
          LoadingButton(
            isLoading: isCreatingAccount,
            onPressed: onRegister,
            child: Text(appLocalizations.registerButtonText),
          ),
        ],
      ),
    );
  }
}
