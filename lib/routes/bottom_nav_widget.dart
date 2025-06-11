import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/app_auth_provider.dart';
import 'package:story_app/routes/app_path.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/routes/bottom_nav_route.dart';
import 'package:story_app/routes/fav_router_delegate.dart';
import 'package:story_app/routes/home_router_delegate.dart';
import 'package:story_app/screen/settings/settings_screen.dart';

import '/l10n/app_localizations.dart';

class BottomNavWidget extends StatefulWidget {
  final BottomNavRoute bottomNavRoute;
  const BottomNavWidget({super.key, required this.bottomNavRoute});

  @override
  State<BottomNavWidget> createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  late AppRoute _appRoute;
  late HomeRouterDelegate _homeRouterDelegate;
  late FavRouterDelegate _favRouterDelegate;

  @override
  void initState() {
    super.initState();
    widget.bottomNavRoute.initRoute();
    _appRoute = context.read<AppRoute>();
    _homeRouterDelegate = HomeRouterDelegate(_appRoute);
    _favRouterDelegate = FavRouterDelegate(_appRoute);

    _appRoute.addListener(_routeListener);

    // Future.microtask(() {
    //   if (!mounted) return;
    //   context.read<FavoriteListProvider>().getAll();
    // });
  }

  @override
  void dispose() {
    _appRoute.removeListener(_routeListener);
    super.dispose();
  }

  void _routeListener() {
    if (_appRoute.path is BottomNavPath) {
      final path = _appRoute.path as BottomNavPath;
      widget.bottomNavRoute.pushPath(path);
    }
  }

  ChildBackButtonDispatcher get childBackButtonDispatcher =>
      ChildBackButtonDispatcher(Router.of(context).backButtonDispatcher!)
        ..takePriority();

  List<Widget> get bottomNavStack => [
    Router(
      routerDelegate: _homeRouterDelegate,
      backButtonDispatcher:
          widget.bottomNavRoute.currentIndex == 0
              ? childBackButtonDispatcher
              : null,
    ),
    Router(
      routerDelegate: _favRouterDelegate,
      backButtonDispatcher:
          widget.bottomNavRoute.currentIndex == 1
              ? childBackButtonDispatcher
              : null,
    ),
    SizedBox(),
    SettingsScreen(),
    SizedBox(),
  ];

  AppLocalizations get appLocalizations =>
      AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

  List<Map<String, Object>> get navData => [
    {"label": appLocalizations.labelHome, "icon": Icon(Icons.home)},
    {"label": appLocalizations.labelFavorite, "icon": Icon(Icons.favorite)},
    {"label": appLocalizations.labelAdd, "icon": Icon(Icons.add)},
    {"label": appLocalizations.labelSettings, "icon": Icon(Icons.settings)},
    {"label": appLocalizations.labelSignOut, "icon": Icon(Icons.logout)},
  ];

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Row(
        children: [
          if (!isPortrait)
            NavigationRail(
              leading: SizedBox(height: 60),
              backgroundColor: ColorScheme.of(context).surfaceContainer,
              extended: true,
              selectedIndex: widget.bottomNavRoute.currentIndex,
              destinations:
                  navData
                      .map(
                        (data) => NavigationRailDestination(
                          icon: data["icon"] as Icon,
                          label: Text(data["label"] as String),
                        ),
                      )
                      .toList(),
              onDestinationSelected: _onDestinationSelected,
            ),
          Expanded(
            child: IndexedStack(
              index: widget.bottomNavRoute.currentIndex,
              children: bottomNavStack,
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          isPortrait
              ? NavigationBar(
                key: ValueKey(widget.bottomNavRoute.currentIndex),
                selectedIndex: widget.bottomNavRoute.currentIndex,
                destinations:
                    navData
                        .map(
                          (data) => NavigationDestination(
                            icon: data["icon"] as Icon,
                            label: data["label"] as String,
                          ),
                        )
                        .toList(),
                onDestinationSelected: _onDestinationSelected,
              )
              : null,
    );
  }

  void _onDestinationSelected(value) {
    switch (value) {
      case 0:
        _appRoute.go("/app/home");
      case 1:
        _appRoute.go("/app/fav");
      case 2:
        _appRoute.go("/app/add");
      case 3:
        _appRoute.go("/app/settings");
      case 4:
        context.read<AppAuthProvider>().logoutUser();
        _appRoute.go("/login");
    }
  }
}
