import 'package:flutter/widgets.dart';
import 'package:story_app/routes/app_path.dart';

class AppRoute extends ChangeNotifier {
  AppPath? Function(AppPath)? redirect;

  AppRoute({this.redirect});

  AppPath _path = LoginPath();
  AppPath get path => _path;

  void changePath(AppPath newPath) {
    _path = redirect?.call(newPath) ?? newPath;
    notifyListeners();
  }

  void go(String uri) {
    changePath(AppPath.fromUri(Uri.parse(uri)));
  }

  void onLogin() => changePath(LoginPath());
  void onRegister() => changePath(RegisterPath());
  void onHome() => changePath(HomePath());
  void onHomeDetail(String id) => changePath(HomeDetailPath(id: id));
  void onFav() => changePath(FavPath());
  void onFavDetail(String id) => changePath(FavDetailPath(id: id));
  void onAdd() => changePath(AddPath());
  void onSettings() => changePath(SettingsPath());
}
