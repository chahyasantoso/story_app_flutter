import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/routes/app_router_delegate.dart';
import 'package:story_app/style/colors/story_colors.dart';
import 'package:story_app/style/typography/story_text_styles.dart';
import 'package:story_app/widget/adaptive_header_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: AdaptiveHeaderLayout(
        headerSize: 0.2,
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
                AppLocalizations.of(context)!.login,
                style: StoryTextStyles.headlineLarge.copyWith(
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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          alignment: isPortrait ? Alignment.topCenter : Alignment.center,
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          spacing: 16,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.emailLabelText,
                hintText: AppLocalizations.of(context)!.emailHintText,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.passwordLabelText,
                hintText: AppLocalizations.of(context)!.passwordHintText,
              ),
            ),
            FilledButton(
              onPressed: () {
                context.read<AppRouterDelegate>().doLogin();
              },
              child: Text(AppLocalizations.of(context)!.login),
            ),
          ],
        ),
      ),
    );
  }
}
