import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:story_app/routes/bottom_nav_widget.dart';
import 'package:story_app/screen/landing/landing_screen.dart';
import 'package:story_app/screen/login/login_screen.dart';
import 'package:story_app/screen/register/register_screen.dart';

sealed class AuthPageConfiguration {
  String toLocation();
  static AuthPageConfiguration fromUri(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      return LandingPageConfiguration();
    } else if (uri.pathSegments.length == 1) {
      final first = uri.pathSegments[0].toLowerCase();
      if (first == 'landing') {
        return LandingPageConfiguration();
      } else if (first == 'login') {
        return LoginPageConfiguration();
      } else if (first == 'register') {
        return RegisterPageConfiguration();
      }
    }
    return UnknownPageConfiguration();
  }
}

final class LandingPageConfiguration extends AuthPageConfiguration {
  @override
  String toLocation() => "/landing";
}

final class LoginPageConfiguration extends AuthPageConfiguration {
  @override
  String toLocation() => "/login";
}

final class RegisterPageConfiguration extends AuthPageConfiguration {
  @override
  String toLocation() => "/register";
}

final class UnknownPageConfiguration extends AuthPageConfiguration {
  @override
  String toLocation() => "/unknown";
}

class AuthRouteParser extends RouteInformationParser<AuthPageConfiguration> {
  @override
  RouteInformation? restoreRouteInformation(
      AuthPageConfiguration configuration) {
    return RouteInformation(uri: Uri.parse(configuration.toLocation()));
  }

  @override
  Future<AuthPageConfiguration> parseRouteInformation(
      RouteInformation routeInformation) {
    return SynchronousFuture(
        AuthPageConfiguration.fromUri(routeInformation.uri));
  }
}

class AuthRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final _navigatorKey = GlobalKey<NavigatorState>();

  bool _isLoggedIn = true;
  bool _isLogin = false;
  bool _isRegister = false;

  void onLogin() {
    _isLogin = true;
    _isRegister = false;
    notifyListeners();
  }

  void onRegister() {
    _isLogin = false;
    _isRegister = true;
    notifyListeners();
  }

  void onLogout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void doLogin() {
    _isLoggedIn = true;
    notifyListeners();
  }

  List<Page<dynamic>> get _loggedOutStack => [
        MaterialPage(
          key: ValueKey("LandingScreen"),
          child: LandingScreen(),
        ),
        if (_isLogin)
          const MaterialPage(
            key: ValueKey("LoginScreen"),
            child: LoginScreen(),
          ),
        if (_isRegister)
          const MaterialPage(
            key: ValueKey("RegisterScreen"),
            child: RegisterScreen(),
          ),
      ];

  List<Page<dynamic>> get _loggedInStack => [
        MaterialPage(
          key: ValueKey("ListScreen"),
          child: BottomNavWidget(),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final navStack = _isLoggedIn ? _loggedInStack : _loggedOutStack;
    return Navigator(
      key: _navigatorKey,
      pages: navStack,
      onDidRemovePage: (page) {
        if (page.key == ValueKey("LoginScreen")) {
          _isLogin = false;
          notifyListeners();
        } else if (page.key == ValueKey("RegisterScreen")) {
          _isRegister = false;
          notifyListeners();
        }
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }
}
