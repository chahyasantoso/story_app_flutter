import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:story_app/app_multi_providers.dart';
import 'package:story_app/provider/favorite_list_provider.dart';
import 'package:story_app/provider/settings_provider.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/routes/app_route_parser.dart';
import 'package:story_app/routes/app_router_delegate.dart';
import 'package:story_app/static/flavor_type.dart';
import 'package:story_app/style/colors/story_colors.dart';
import 'package:story_app/style/theme/story_theme.dart';

import '/l10n/app_localizations.dart';

void main() async {
  FlavorConfig(
    flavor: FlavorType.free,
    storyColor: StoryColors.orange,
    assetBackground: "assets/images/background_stars_free.png",
    values: const FlavorValues(titleApp: "StoryApp (free version)"),
  );

  WidgetsFlutterBinding.ensureInitialized();
  /* for next feature, sign in with google
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final firebaseAuth = FirebaseAuth.instance; */
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  runApp(AppMultiProviders(child: const MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late AppRoute appRoute;
  late AppRouterDelegate appRouterDelegate;
  late SettingsProvider settingsProvider;
  late FavoriteListProvider favoriteListProvider;

  @override
  void initState() {
    super.initState();
    appRoute = context.read<AppRoute>();
    appRouterDelegate = AppRouterDelegate(appRoute);
    settingsProvider = context.read<SettingsProvider>();
    favoriteListProvider = context.read<FavoriteListProvider>();

    Future.microtask(() {
      settingsProvider.loadSettings();
      favoriteListProvider.getAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<SettingsProvider>().settings.locale;
    final isDarkModeEnabled =
        context.watch<SettingsProvider>().settings.isDarkModeEnabled;

    return MaterialApp.router(
      title: FlavorConfig.instance.values.titleApp,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: StoryTheme.lightTheme,
      darkTheme: StoryTheme.darkTheme,
      themeMode: isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      routeInformationParser: AppRouteParser(),
      routerDelegate: appRouterDelegate,
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }
}
