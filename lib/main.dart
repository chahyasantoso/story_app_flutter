import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/services/firebase_auth_service.dart';
import 'package:story_app/firebase_options.dart';
import 'package:story_app/provider/firebase_auth_provider.dart';
import 'package:story_app/routes/auth_router_delegate.dart';
import 'package:story_app/routes/main_router_delegate.dart';
import 'package:story_app/screen/landing/landing_screen.dart';
import 'package:story_app/screen/login/login_screen.dart';
import 'package:story_app/screen/register/register_screen.dart';
import 'package:story_app/style/theme/story_theme.dart';
import 'package:story_app/style/typography/story_text_styles.dart';
import 'package:story_app/widget/adaptive_header_layout.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final firebaseAuth = FirebaseAuth.instance;
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => FirebaseAuthService(firebaseAuth),
        ),
        ChangeNotifierProvider(
          create: (context) => FirebaseAuthProvider(
            context.read<FirebaseAuthService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthRouterDelegate(),
        ),
        ChangeNotifierProvider(
          create: (context) => MainRouterDelegate(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "StoryApp",
      //locale: Locale("id"),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: StoryTheme.lightTheme,
      darkTheme: StoryTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: Router(
        routerDelegate: context.read<AuthRouterDelegate>(),
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
