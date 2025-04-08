import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:story_app/routes/app_path.dart';
import 'package:story_app/routes/bottom_nav_widget.dart';
import 'package:story_app/screen/landing/landing_screen.dart';
import 'package:story_app/screen/login/login_screen.dart';
import 'package:story_app/screen/register/register_screen.dart';

class AppRouterDelegate extends RouterDelegate<AppPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final _navigatorKey = GlobalKey<NavigatorState>();

  late AppPath _state;
  late AppNavigatorObserver _observer;
  AppRouterDelegate() {
    _state = LandingPath();
    _observer = AppNavigatorObserver(() {
      onBackButtonPressed(true);
    });
  }

  void onLogin() {
    _state = LoginPath();
    notifyListeners();
  }

  void onRegister() {
    _state = RegisterPath();
    notifyListeners();
  }

  void onLogout() {
    _state = LandingPath();
    notifyListeners();
  }

  void doLogin() {
    _state = ListPath();
    notifyListeners();
  }

  List<Page<dynamic>> get _loggedOutStack => [
        MaterialPage(
          key: ValueKey("LandingScreen"),
          child: LandingScreen(),
        ),
        if (_state is LoginPath)
          MaterialPage(
            key: ValueKey("LoginScreen"),
            child: LoginScreen(),
          ),
        if (_state is RegisterPath)
          MaterialPage(
            key: ValueKey("RegisterScreen"),
            child: RegisterScreen(),
          ),
      ];

  List<Page<dynamic>> get _loggedInStack => [
        MaterialPage(
          key: ValueKey("MainScreen"),
          child: BottomNavWidget(
            state: (_state as MainPath),
            onTap: (value) {
              switch (value) {
                case 0:
                  onHome();
                case 1:
                  onSettings();
              }
            },
          ),
        ),
      ];

  void onHome() {
    _state = ListPath();
    notifyListeners();
  }

  void onSettings() {
    _state = SettingsPath();
    notifyListeners();
  }

  void onDetail() {
    _state = DetailPath("1");
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final navStack = switch (_state) {
      MainPath() => _loggedInStack,
      _ => _loggedOutStack,
    };
    return Navigator(
      key: _navigatorKey,
      observers: [_observer],
      pages: navStack,
      onDidRemovePage: (page) {},
    );
  }

  bool onBackButtonPressed(bool didPop) {
    if (didPop) {
      if (_state is LoginPath) {
        _state = LandingPath();
        notifyListeners();
      } else if (_state is RegisterPath) {
        _state = LandingPath();
        notifyListeners();
      }
    }
    return didPop;
  }

  @override
  Future<bool> popRoute() async {
    return onBackButtonPressed(await super.popRoute());
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  AppPath? get currentConfiguration => _state;

  @override
  Future<void> setNewRoutePath(AppPath configuration) async {
    print("setNewRoutePath: $configuration");
    _state = configuration;
    notifyListeners();
  }
}

class AppNavigatorObserver extends NavigatorObserver {
  final Function onDidPop;
  AppNavigatorObserver(this.onDidPop);

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    onDidPop();
  }
}
