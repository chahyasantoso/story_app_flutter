import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/services/firebase_auth_service.dart';
import 'package:story_app/data/services/shared_preferences_service.dart';
import 'package:story_app/data/services/story_api_service.dart';
import 'package:story_app/firebase_options.dart';
import 'package:story_app/provider/firebase_auth_provider.dart';
import 'package:story_app/provider/story_auth_provider.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/routes/app_route_parser.dart';
import 'package:story_app/routes/app_route_path.dart';
import 'package:story_app/routes/app_router_delegate.dart';
import 'package:story_app/static/auth_status.dart';
import 'package:story_app/style/theme/story_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = SharedPreferencesAsync();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final firebaseAuth = FirebaseAuth.instance;

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => SharedPreferencesService(pref),
        ),
        Provider(
          create: (context) => StoryApiService(),
        ),
        ChangeNotifierProvider(
          create: (context) => StoryAuthProvider(
            storyApiService: context.read<StoryApiService>(),
            prefService: context.read<SharedPreferencesService>(),
          ),
        ),
        // Provider(
        //   create: (context) => FirebaseAuthService(firebaseAuth),
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => FirebaseAuthProvider(
        //     context.read<FirebaseAuthService>(),
        //   ),
        // ),
        ChangeNotifierProvider(
          create: (context) => AppRoute(
            redirect: (AppRoutePath path) {
              final isLoggedIn =
                  context.read<StoryAuthProvider>().authStatus is Authenticated;
              return !isLoggedIn
                  ? (path is AuthenticatedRoutePath ? LandingRoutePath() : null)
                  : (path is! AuthenticatedRoutePath ? HomeRoutePath() : null);
            },
          ),
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
    return MaterialApp.router(
      title: "StoryApp",
      //locale: Locale("id"),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: StoryTheme.lightTheme,
      darkTheme: StoryTheme.darkTheme,
      themeMode: ThemeMode.light,
      routeInformationParser: AppRouteParser(),
      routerDelegate: AppRouterDelegate(context.read<AppRoute>()),
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }
}
