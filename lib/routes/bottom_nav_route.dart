import 'package:story_app/routes/app_path.dart';

class BottomNavRoute {
  List<BottomNavPath> _pathStack = [HomePath()];
  List<BottomNavPath> get pathStack => _pathStack;
  BottomNavPath get currentPath => _pathStack.last;
  int get currentIndex => switch (currentPath) {
        HomePath() => 0,
        FavPath() => 1,
        SettingsPath() => 3,
      };

  final int _maxIndexLength = 5;

  void pushPath(BottomNavPath appPath) {
    if (currentPath.runtimeType != appPath.runtimeType) {
      final lastNItems =
          _pathStack.reversed.take(_maxIndexLength - 1).toList().reversed;
      _pathStack = [...lastNItems, appPath];
    }
  }

  bool popPath() {
    if (_pathStack.length > 1) {
      _pathStack = [..._pathStack..removeLast()];
      return true;
    }
    return false;
  }

  void reset() {
    _pathStack = [HomePath()];
  }
}
