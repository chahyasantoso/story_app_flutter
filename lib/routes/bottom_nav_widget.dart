import 'package:flutter/material.dart';
import 'package:story_app/routes/app_path.dart';
import 'package:story_app/routes/main_router_delegate.dart';

class BottomNavWidget extends StatefulWidget {
  final MainPath state;
  final ValueChanged<int> onTap;
  const BottomNavWidget({super.key, required this.state, required this.onTap});

  @override
  State<BottomNavWidget> createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  int get currentIndex => widget.state.index;

  @override
  Widget build(BuildContext context) {
    final childBackButtonDispatcher =
        ChildBackButtonDispatcher(Router.of(context).backButtonDispatcher!);
    childBackButtonDispatcher.takePriority();

    return Scaffold(
      body: Router(
        routerDelegate: MainRouterDelegate(state: widget.state),
        backButtonDispatcher: childBackButtonDispatcher,
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
        onTap: widget.onTap,
      ),
    );
  }
}
