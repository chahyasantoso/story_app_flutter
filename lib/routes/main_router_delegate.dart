import 'package:flutter/material.dart';
import 'package:story_app/screen/detail/detail_screen.dart';
import 'package:story_app/screen/home/list_screen.dart';
import 'package:story_app/screen/settings/settings_screen.dart';

class MainRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final _navigatorKey = GlobalKey<NavigatorState>();

  bool isHome = true;
  bool isDetail = false;
  bool isSettings = false;

  void initRoute() {
    isHome = true;
    isDetail = false;
    isSettings = false;
  }

  void onHome() {
    isHome = true;
    isSettings = false;
    notifyListeners();
  }

  void onDetail() {
    isDetail = true;
    notifyListeners();
  }

  void onSettings() {
    isHome = false;
    isSettings = true;
    notifyListeners();
  }

  List<Page<dynamic>> get homeStack => [
        MaterialPage(
          key: ValueKey("ListScreen"),
          child: ListScreen(),
        ),
        if (isDetail)
          MaterialPage(
            key: ValueKey("DetailScreen"),
            child: DetailScreen(),
          ),
      ];

  List<Page<dynamic>> get settingsStack => [
        MaterialPage(
          key: ValueKey("SettingsScreen"),
          child: SettingsScreen(),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    List<Page<dynamic>> navStack = [];
    if (isHome) {
      navStack = homeStack;
    } else if (isSettings) {
      navStack = settingsStack;
    }

    return Navigator(
      key: _navigatorKey,
      pages: navStack,
      onDidRemovePage: (page) {
        if (page.key == ValueKey("DetailScreen")) {
          isDetail = false;
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
