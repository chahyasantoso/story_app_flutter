import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/services/story_api_service.dart';
import 'package:story_app/provider/story_detail_provider.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/routes/app_path.dart';
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
        MaterialPage(
          key: ValueKey("HomeScreen"),
          child: HomeScreen(),
        ),
        if (_appRoute.path is HomeDetailPath)
          MaterialPage(
            key: ValueKey("DetailScreen"),
            child: Builder(
              builder: (context) {
                final apiService = context.read<StoryApiService>();
                final id = (_appRoute.path as HomeDetailPath).id;
                return ChangeNotifierProvider(
                  create: (context) => StoryDetailProvider(apiService),
                  child: DetailScreen(id: id),
                );
              },
            ),
          ),
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
            _appRoute.onHome();
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
