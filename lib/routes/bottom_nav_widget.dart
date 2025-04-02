import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/routes/main_router_delegate.dart';

class BottomNavWidget extends StatefulWidget {
  const BottomNavWidget({super.key});

  @override
  State<BottomNavWidget> createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  late MainRouterDelegate _routerDelegate;

  @override
  void initState() {
    _routerDelegate = context.read<MainRouterDelegate>();
    _routerDelegate.initRoute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<MainRouterDelegate>().isHome ? 0 : 1;
    return Scaffold(
      body: Router(
        routerDelegate: _routerDelegate,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        onTap: (value) {
          switch (value) {
            case 0:
              _routerDelegate.onHome();
            case 1:
              _routerDelegate.onSettings();
          }
        },
      ),
    );
  }
}
