import 'package:flutter/widgets.dart';
import 'package:story_app/routes/app_route_path.dart';

class AppRoute extends ChangeNotifier {
  final AppRoutePath? Function(AppRoutePath)? redirect;
  AppRoute({this.redirect});

  AppRoutePath _path = LandingRoutePath();
  AppRoutePath get path => _path;

  void changePath(AppRoutePath newPath) {
    _path = redirect?.call(newPath) ?? newPath;
    notifyListeners();
  }

  void go(String uri) {
    changePath(AppRoutePath.fromUri(Uri.parse(uri)));
  }

  int toBottomNavIndex() {
    return switch (path) {
      HomeSubRoutePath() => 0,
      FavSubRoutePath() => 1,
      SettingsRoutePath() => 2,
      _ => 0,
    };
  }

  void onLanding() => changePath(LandingRoutePath());
  void onLogin() => changePath(LoginRoutePath());
  void onRegister() => changePath(RegisterRoutePath());
  void onHome() => changePath(HomeRoutePath());
  void onHomeDetail(String id) => changePath(HomeDetailRoutePath(id: id));
  void onFav() => changePath(FavRoutePath());
  void onFavDetail(String id) => changePath(FavDetailRoutePath(id: id));
  void onAdd() => changePath(AddRoutePath());
  void onSettings() => changePath(SettingsRoutePath());
}
