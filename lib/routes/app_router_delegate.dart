import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/services/story_api_service.dart';
import 'package:story_app/provider/story_add_provider.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/routes/app_path.dart';
import 'package:story_app/routes/bottom_nav_route.dart';
import 'package:story_app/routes/bottom_nav_widget.dart';
import 'package:story_app/screen/add/add_screen.dart';
import 'package:story_app/screen/login/login_screen.dart';
import 'package:story_app/screen/register/register_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:story_app/static/snack_bar_utils.dart';

class AppRouterDelegate extends RouterDelegate<AppPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin, SnackBarUtils {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final AppRoute _appRoute;

  AppRouterDelegate(this._appRoute) {
    _appRoute.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _appRoute.removeListener(notifyListeners);
    super.dispose();
  }

  List<Page<dynamic>> get _loggedOutStack => [
        MaterialPage(
          key: ValueKey("LoginScreen"),
          child: LoginScreen(),
        ),
        if (_appRoute.path is RegisterPath)
          MaterialPage(
            key: ValueKey("RegisterScreen"),
            child: RegisterScreen(),
          ),
      ];

  AppLocalizations get appLocalizations {
    final context = _navigatorKey.currentContext;
    if (context != null) {
      return AppLocalizations.of(context) ??
          lookupAppLocalizations(Locale('en'));
    }
    return lookupAppLocalizations(Locale('en'));
  }

  bool canPop = false;
  final BottomNavRoute _bottomNavRoute = BottomNavRoute();
  List<Page<dynamic>> get _loggedInStack => [
        MaterialPage(
          key: ValueKey("BottomNavWidget"),
          child: PopScope(
            canPop: canPop,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              final context = _navigatorKey.currentContext!;
              showSnackBar(context, appLocalizations.messageBackToExit);
              canPop = true;
              notifyListeners();
              Future.delayed(const Duration(seconds: 2), () {
                canPop = false;
                notifyListeners();
              });
            },
            child: BottomNavWidget(bottomNavRoute: _bottomNavRoute),
          ),
        ),
        if (_appRoute.path is AddPath)
          MaterialPage(
            key: ValueKey("AddScreen"),
            child: ChangeNotifierProvider(
              create: (context) => StoryAddProvider(
                context.read<StoryApiService>(),
              ),
              child: AddScreen(),
            ),
          ),
      ];

  @override
  Widget build(BuildContext context) {
    final navStack =
        _appRoute.path is AuthenticatedPath ? _loggedInStack : _loggedOutStack;

    return Navigator(
      key: _navigatorKey,
      pages: navStack,
      onDidRemovePage: (page) {
        final topPage = navStack.last;
        if (topPage.key == page.key) {
          if (_appRoute.path is RegisterPath) {
            _appRoute.onLogin();
          } else if (_appRoute.path is AddPath) {
            _appRoute.changePath(_bottomNavRoute.currentPath);
          }
        }
      },
    );
  }

  @override
  Future<bool> popRoute() async {
    final isBottomNavPath = _appRoute.path is BottomNavPath;
    if (isBottomNavPath && _bottomNavRoute.popPath() == true) {
      return true;
    }
    return super.popRoute();
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  AppPath? get currentConfiguration => _appRoute.path;

  @override
  Future<void> setNewRoutePath(AppPath configuration) async {
    print("setNewPath: $configuration");
    _appRoute.changePath(configuration);
  }
}
