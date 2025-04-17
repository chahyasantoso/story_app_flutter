import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/routes/bottom_nav_route.dart';
import 'package:story_app/routes/fav_router_delegate.dart';
import 'package:story_app/routes/home_router_delegate.dart';
import 'package:story_app/screen/settings/settings_screen.dart';

class BottomNavWidget extends StatefulWidget {
  final BottomNavRoute? bottomNavRoute;
  const BottomNavWidget({
    super.key,
    required this.bottomNavRoute,
  });

  @override
  State<BottomNavWidget> createState() => BottomNavWidgetState();
}

class BottomNavWidgetState extends State<BottomNavWidget> {
  late AppRoute _appRoute;
  late HomeRouterDelegate _homeRouterDelegate;
  late FavRouterDelegate _favRouterDelegate;

  @override
  void initState() {
    super.initState();
    _appRoute = context.read<AppRoute>();
    _homeRouterDelegate = HomeRouterDelegate(_appRoute);
    _favRouterDelegate = FavRouterDelegate(_appRoute);
    widget.bottomNavRoute?.reset();
  }

  ChildBackButtonDispatcher get childBackButtonDispatcher =>
      ChildBackButtonDispatcher(Router.of(context).backButtonDispatcher!)
        ..takePriority();

  int get selectedIndex =>
      widget.bottomNavRoute?.currentIndex ?? _appRoute.toBottomNavIndex();

  List<Widget> get bottomNavStack => [
        Router(
          routerDelegate: _homeRouterDelegate,
          backButtonDispatcher:
              selectedIndex == 0 ? childBackButtonDispatcher : null,
        ),
        Router(
          routerDelegate: _favRouterDelegate,
          backButtonDispatcher:
              selectedIndex == 1 ? childBackButtonDispatcher : null,
        ),
        SettingsScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: bottomNavStack,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        onTap: (value) {
          widget.bottomNavRoute?.push(value);
          switch (value) {
            case 0:
              _appRoute.onHome();
            case 1:
              _appRoute.onFav();
            case 2:
              _appRoute.onSettings();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
