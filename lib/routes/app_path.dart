sealed class AppPath {
  Uri toUri();
  static AppPath fromUri(Uri uri) {
    if (uri.pathSegments.isEmpty) {
      return LandingPath();
    } else if (uri.pathSegments.length == 1) {
      final first = uri.pathSegments[0].toLowerCase();
      if (first == 'main' || first == 'list') {
        return ListPath();
      } else if (first == 'settings') {
        return SettingsPath();
      } else if (first == 'landing') {
        return LandingPath();
      } else if (first == 'login') {
        return LoginPath();
      } else if (first == 'register') {
        return RegisterPath();
      }
    } else if (uri.pathSegments.length == 2) {
      final first = uri.pathSegments[0].toLowerCase();
      final second = uri.pathSegments[1].toLowerCase();
      if (first == 'list' && second.isNotEmpty) {
        return DetailPath(second);
      }
    }
    return UnknownPath();
  }
}

final class LandingPath extends AppPath {
  @override
  Uri toUri() => Uri.parse("/landing");
}

final class LoginPath extends AppPath {
  @override
  Uri toUri() => Uri.parse("/login");
}

final class RegisterPath extends AppPath {
  @override
  Uri toUri() => Uri.parse("/register");
}

final class UnknownPath extends AppPath {
  @override
  Uri toUri() => Uri.parse("/404");
}

sealed class MainPath extends AppPath {
  int get index;
}

class ListPath extends MainPath {
  @override
  Uri toUri() => Uri.parse("/list");
  @override
  int get index => 0;
}

class DetailPath extends MainPath {
  final String id;
  DetailPath(this.id);

  @override
  Uri toUri() => Uri.parse("/list/$id");
  @override
  int get index => 0;
}

class SettingsPath extends MainPath {
  @override
  Uri toUri() => Uri.parse("/settings");
  @override
  int get index => 1;
}
