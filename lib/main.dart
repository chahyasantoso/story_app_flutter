import 'dart:ui';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:story_app/data/services/location_service.dart';
import 'package:story_app/data/services/shared_preferences_service.dart';
import 'package:story_app/data/services/sqlite_service.dart';
import 'package:story_app/data/services/story_api_service.dart';
import 'package:story_app/data/services/story_auth_service.dart';
import 'package:story_app/provider/app_auth_provider.dart';
import 'package:story_app/provider/favorite_list_provider.dart';
import 'package:story_app/provider/favorite_mutation_provider.dart';
import 'package:story_app/provider/geocoding_provider.dart';
import 'package:story_app/provider/location_provider.dart';
import 'package:story_app/provider/settings_provider.dart';
import 'package:story_app/provider/story_list_provider.dart';
import 'package:story_app/routes/app_path.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/routes/app_route_parser.dart';
import 'package:story_app/routes/app_router_delegate.dart';
import 'package:story_app/static/auth_state.dart';
import 'package:story_app/static/flavor_type.dart';
import 'package:story_app/style/theme/story_theme.dart';

import '/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = SharedPreferencesAsync();
  /* for next feature, sign in with google
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final firebaseAuth = FirebaseAuth.instance; */
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => SharedPreferencesService(pref)),
        Provider(create: (_) => StoryAuthService()),
        Provider(create: (_) => SqliteService()),
        Provider(create: (_) => LocationService()),
        ChangeNotifierProvider(
          create:
              (context) => AppAuthProvider(
                storyAuthService: context.read<StoryAuthService>(),
                prefService: context.read<SharedPreferencesService>(),
              ),
        ),
        ProxyProvider<AppAuthProvider, StoryApiService>(
          update: (context, authProvider, prev) {
            final service = prev ?? StoryApiService();
            return service..token = authProvider.userProfile?.token ?? "";
          },
        ),
        ChangeNotifierProvider(
          create:
              (context) => AppRoute(
                redirect: (AppPath path) {
                  final isLoggedIn =
                      context.read<AppAuthProvider>().authState
                          is AuthAuthenticated;
                  return !isLoggedIn
                      ? (path is AuthenticatedPath ? LoginPath() : null)
                      : (path is! AuthenticatedPath ? HomePath() : null);
                },
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => StoryListProvider(context.read<StoryApiService>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  SettingsProvider(context.read<SharedPreferencesService>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  FavoriteMutationProvider(context.read<SqliteService>()),
        ),
        ChangeNotifierProxyProvider<
          FavoriteMutationProvider,
          FavoriteListProvider
        >(
          create:
              (context) => FavoriteListProvider(context.read<SqliteService>()),
          update: (context, favMutationProvider, prev) {
            if (prev == null) {
              return FavoriteListProvider(context.read<SqliteService>());
            }
            prev.onMutation(favMutationProvider);
            return prev;
          },
        ),
        ChangeNotifierProvider(
          create:
              (context) => LocationProvider(context.read<LocationService>()),
        ),
        ChangeNotifierProvider(create: (_) => GeocodingProvider()),
      ],
      child: const AppDevicePreview(),
    ),
  );
}

class AppDevicePreview extends StatelessWidget {
  const AppDevicePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      backgroundColor: Colors.white,
      enabled: kIsWeb,
      defaultDevice: Devices.android.samsungGalaxyA50,
      isToolbarVisible: true,
      availableLocales: [Locale('en', 'US')],
      tools: const [
        DeviceSection(
          model: true,
          orientation: false,
          frameVisibility: false,
          virtualKeyboard: false,
        ),
      ],
      devices: [
        Devices.android.samsungGalaxyA50,
        Devices.android.samsungGalaxyNote20,
        Devices.android.samsungGalaxyS20,
        Devices.android.samsungGalaxyNote20Ultra,
        Devices.android.onePlus8Pro,
        Devices.android.sonyXperia1II,
        Devices.ios.iPhoneSE,
        Devices.ios.iPhone13,
        Devices.ios.iPhone13ProMax,
        Devices.ios.iPhone13Mini,
        Devices.ios.iPhoneSE,
      ],
      builder: (context) => const MainApp(),
    );
  }
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
      builder: DevicePreview.appBuilder,
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
