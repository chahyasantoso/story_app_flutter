import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/routes/app_route_path.dart';
import 'package:story_app/routes/bottom_nav_route.dart';
import 'package:story_app/routes/bottom_nav_widget.dart';
import 'package:story_app/screen/landing/landing_screen.dart';
import 'package:story_app/screen/login/login_screen.dart';
import 'package:story_app/screen/register/register_screen.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final AppRoute _appRoute;
  final BottomNavRoute? _bottomNavRoute = !kIsWeb ? BottomNavRoute() : null;

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
          key: ValueKey("LandingScreen"),
          child: LandingScreen(),
        ),
        if (_appRoute.path is LoginRoutePath)
          MaterialPage(
            key: ValueKey("LoginScreen"),
            child: LoginScreen(),
          ),
        if (_appRoute.path is RegisterRoutePath)
          MaterialPage(
            key: ValueKey("RegisterScreen"),
            child: RegisterScreen(),
          ),
      ];

  bool canPop = false;
  List<Page<dynamic>> get _loggedInStack => [
        MaterialPage(
          key: ValueKey("BottomNavWidget"),
          child: PopScope(
            canPop: canPop,
            onPopInvokedWithResult: (didPop, result) {
              final context = _navigatorKey.currentContext!;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text("Press back again to exit"),
                  duration: Duration(seconds: 2),
                ),
              );
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
      ];

  @override
  Widget build(BuildContext context) {
    final navStack = _appRoute.path is AuthenticatedRoutePath
        ? _loggedInStack
        : _loggedOutStack;

    return Navigator(
      key: _navigatorKey,
      pages: navStack,
      onDidRemovePage: (page) {
        final topPage = navStack.last;
        if (topPage.key == page.key) {
          onBackButtonPressed();
        }
      },
    );
  }

  void onBackButtonPressed() {
    if (_appRoute.path is LoginRoutePath) {
      _appRoute.onLanding();
    } else if (_appRoute.path is RegisterRoutePath) {
      _appRoute.onLanding();
    }
  }

  @override
  Future<bool> popRoute() async {
    final isAuthenticatedRoutePath = _appRoute.path is AuthenticatedRoutePath;
    final isBottomNavRoutePop =
        isAuthenticatedRoutePath && _bottomNavRoute?.pop() == true;
    if (isBottomNavRoutePop) {
      return true;
    }
    return super.popRoute();
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  AppRoutePath? get currentConfiguration => _appRoute.path;

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    print("setNewRoutePath: $configuration");
    _appRoute.changePath(configuration);
  }
}
