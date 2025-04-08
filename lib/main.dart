import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/services/firebase_auth_service.dart';
import 'package:story_app/firebase_options.dart';
import 'package:story_app/provider/firebase_auth_provider.dart';
import 'package:story_app/routes/app_route_parser.dart';
import 'package:story_app/routes/app_router_delegate.dart';
import 'package:story_app/style/theme/story_theme.dart';
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
          create: (context) => AppRouterDelegate(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late AppRouteParser _routeParser;
  late PlatformRouteInformationProvider _routeInformationProvider;

  @override
  void initState() {
    super.initState();
    _routeParser = AppRouteParser();
    _routeInformationProvider = PlatformRouteInformationProvider(
      initialRouteInformation: RouteInformation(
        uri: Uri.parse("/"),
      ),
    );
  }

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
      routeInformationParser: _routeParser,
      routeInformationProvider: _routeInformationProvider,
      routerDelegate: context.read<AppRouterDelegate>(),
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }
}
