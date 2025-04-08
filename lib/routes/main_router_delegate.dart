import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/routes/app_path.dart';
import 'package:story_app/routes/app_router_delegate.dart';
import 'package:story_app/screen/detail/detail_screen.dart';
import 'package:story_app/screen/home/list_screen.dart';
import 'package:story_app/screen/settings/settings_screen.dart';

final mainNavigatorKey = GlobalKey<NavigatorState>();

class MainRouterDelegate extends RouterDelegate<MainPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final _navigatorKey = mainNavigatorKey;

  MainPath state;
  late AppNavigatorObserver _observer;
  MainRouterDelegate({required this.state}) {
    _observer = AppNavigatorObserver(() {
      print("Main route didPop");
      onBackButtonPressed(true);
    });
  }

  List<Page<dynamic>> get listStack => [
        MaterialPage(
          key: ValueKey("ListScreen"),
          child: ListScreen(),
        ),
        if (state is DetailPath)
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
    final navStack = state.index == 0 ? listStack : settingsStack;
    return Navigator(
      key: _navigatorKey,
      observers: [_observer],
      pages: navStack,
      onDidRemovePage: (page) {},
    );
  }

  bool onBackButtonPressed(bool didPop) {
    final context = _navigatorKey.currentContext;
    if (context != null && didPop) {
      if (state is DetailPath) {
        context.read<AppRouterDelegate>().onHome();
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
  MainPath? get currentConfiguration => state;

  @override
  Future<void> setNewRoutePath(MainPath configuration) async {}
}
