import 'package:flutter/material.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/routes/app_route_path.dart';
import 'package:story_app/screen/detail/detail_screen.dart';
import 'package:story_app/screen/fav/fav_screen.dart';

final favNavigatorKey = GlobalKey<NavigatorState>();

class FavRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final _navigatorKey = favNavigatorKey;
  final AppRoute _appRoute;

  FavRouterDelegate(this._appRoute) {
    _appRoute.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _appRoute.removeListener(notifyListeners);
    super.dispose();
  }

  List<Page<dynamic>> get navStack => [
        MaterialPage(
          key: ValueKey("FavScreen"),
          child: FavScreen(),
        ),
        if (_appRoute.path is FavDetailRoutePath)
          MaterialPage(
            key: ValueKey("DetailScreen"),
            child: DetailScreen(),
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
            "fav router page removed ${page.key}, top of the page ${topPage.key}");
        if (topPage.key == page.key) {
          onBackButtonPressed();
        }
      },
    );
  }

  void onBackButtonPressed() {
    if (_appRoute.path is FavDetailRoutePath) {
      _appRoute.onFav();
    }
  }

  @override
  Future<bool> popRoute() async {
    print("Pop route from fav");
    return super.popRoute();
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  AppRoutePath? get currentConfiguration => _appRoute.path;

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    print("setNewRoutePath from fav");
    _appRoute.changePath(configuration);
  }
}
