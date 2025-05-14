import 'package:flutter/widgets.dart';
import 'package:story_app/routes/app_path.dart';
import 'package:story_app/static/flavor_type.dart';

class AppRoute extends ChangeNotifier {
  AppPath? Function(AppPath)? redirect;

  AppRoute({this.redirect});

  AppPath _path = LoginPath();
  AppPath get path => _path;

  void changePath(AppPath newPath) {
    _path = redirect?.call(newPath) ?? newPath;
    if (FlavorConfig.instance.flavor == FlavorType.free) {
      if (path is AddMapPath) _path = UnknownPath();
    }
    notifyListeners();
  }

  void go(String uriString) {
    changePath(AppPath.fromUri(Uri.parse(uriString)));
  }

  void goBack() {
    final uri = _path.toUri();
    final segments = List<String>.from(uri.pathSegments);
    if (segments.isEmpty) return;

    segments.removeLast();
    final newUri = Uri(pathSegments: segments);
    changePath(AppPath.fromUri(newUri));
  }
}
