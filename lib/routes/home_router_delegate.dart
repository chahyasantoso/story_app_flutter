import 'package:flutter/material.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/routes/app_route_path.dart';
import 'package:story_app/screen/add/add_screen.dart';
import 'package:story_app/screen/detail/detail_screen.dart';
import 'package:story_app/screen/home/home_screen.dart';

final homeNavigatorKey = GlobalKey<NavigatorState>();

class HomeRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final _navigatorKey = homeNavigatorKey;
  final AppRoute _appRoute;

  HomeRouterDelegate(this._appRoute) {
    _appRoute.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _appRoute.removeListener(notifyListeners);
    super.dispose();
  }

  List<Page<dynamic>> get navStack => [
        MaterialPage(
          key: ValueKey("HomeScreen"),
          child: HomeScreen(),
        ),
        if (_appRoute.path is HomeDetailRoutePath)
          MaterialPage(
            key: ValueKey("DetailScreen"),
            child: DetailScreen(),
          ),
        if (_appRoute.path is AddRoutePath)
          MaterialPage(
            key: ValueKey("AddScreen"),
            child: AddScreen(),
          ),
      ];

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      pages: navStack,
      onDidRemovePage: (page) {
        final topPage = navStack.last;
        print(
            "home router page removed ${page.key}, top of the page ${topPage.key}");
        if (topPage.key == page.key) {
          onBackButtonPressed();
        }
      },
    );
  }

  void onBackButtonPressed() async {
    if (_appRoute.path is HomeDetailRoutePath) {
      _appRoute.onHome();
    } else if (_appRoute.path is AddRoutePath) {
      _appRoute.onHome();
    }
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  AppRoutePath? get currentConfiguration => _appRoute.path;

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    print("setNewRoutePath from home");
    _appRoute.changePath(configuration);
  }
}
