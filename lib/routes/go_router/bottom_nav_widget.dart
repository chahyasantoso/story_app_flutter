import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/domain/usecases/story_usecases.dart';
import 'package:story_app/provider/app_auth_provider.dart';
import 'package:story_app/provider/story_add_provider.dart';
import 'package:story_app/provider/story_map_provider.dart';

import '/l10n/app_localizations.dart';

class BottomNavWidget extends StatefulWidget {
  final Widget? child;
  const BottomNavWidget({super.key, required this.child});

  @override
  State<BottomNavWidget> createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
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

    Widget bottomNavChild = MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => StoryAddProvider(context.read<StoryUsecases>()),
        ),
        ChangeNotifierProvider(create: (context) => StoryMapProvider()),
      ],
      child: widget.child,
    );

    return Scaffold(
      body: Row(
        children: [
          if (!isPortrait)
            NavigationRail(
              leading: SizedBox(height: 60),
              backgroundColor: ColorScheme.of(context).surfaceContainer,
              extended: true,
              selectedIndex: _getCurrentIndex(),
              destinations: navData
                  .map(
                    (data) => NavigationRailDestination(
                      icon: data["icon"] as Icon,
                      label: Text(data["label"] as String),
                    ),
                  )
                  .toList(),
              onDestinationSelected: _onDestinationSelected,
            ),
          Expanded(child: bottomNavChild),
        ],
      ),
      bottomNavigationBar: isPortrait
          ? NavigationBar(
              selectedIndex: _getCurrentIndex(),
              destinations: navData
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

  int _getCurrentIndex() {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/fav')) return 1;
    if (location.startsWith('/add')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onDestinationSelected(int value) {
    switch (value) {
      case 0:
        context.go("/home");

      case 1:
        context.go("/fav");

      case 2:
        context.go("/add");

      case 3:
        context.go("/settings");

      case 4:
        context.read<AppAuthProvider>().logoutUser();
        context.go("/login");
    }
  }
}
