import 'package:flutter/material.dart';
import 'package:story_app/routes/app_path.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/screen/detail/detail_screen.dart';
import 'package:story_app/screen/home/home_screen.dart';

final homeNavigatorKey = GlobalKey<NavigatorState>();

class HomeRouterDelegate extends RouterDelegate<AppPath>
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
    MaterialPage(key: ValueKey("HomeScreen"), child: HomeScreen()),
    if (_appRoute.path case HomeDetailPath(id: final String id))
      MaterialPage(key: ValueKey("DetailScreen"), child: DetailScreen(id: id)),
  ];

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      pages: navStack,
      onDidRemovePage: (page) {
        final topPage = navStack.last;
        if (topPage.key == page.key) {
          if (_appRoute.path is HomeDetailPath) {
            _appRoute.goBack();
          }
        }
      },
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  AppPath? get currentConfiguration => _appRoute.path;

  @override
  Future<void> setNewRoutePath(AppPath configuration) async {
    _appRoute.changePath(configuration);
  }
}
