sealed class AppRoutePath {
  static AppRoutePath fromUri(Uri uri) {
    final segments = uri.pathSegments;
    if (segments.isEmpty) {
      return LandingRoutePath();
    }
    switch (segments.first) {
      case 'landing':
        return LandingRoutePath();
      case 'login':
        return LoginRoutePath();
      case 'register':
        return RegisterRoutePath();
      case 'app':
        if (segments.length < 2) return HomeRoutePath();
        switch (segments[1]) {
          case 'home':
            if (segments.length == 4 && segments[2] == 'detail') {
              if (segments[3].isNotEmpty) {
                return HomeDetailRoutePath(id: segments[3]);
              }
            }
            return HomeRoutePath();
          case 'fav':
            if (segments.length == 4 && segments[2] == 'detail') {
              if (segments[3].isNotEmpty) {
                return FavDetailRoutePath(id: segments[3]);
              }
            }
            return FavRoutePath();
          case 'add':
            return AddRoutePath();
          case 'settings':
            return SettingsRoutePath();
        }
        return HomeRoutePath();
    }
    return UnknownRoutePath();
  }

  Uri toUri();
}

sealed class AuthenticatedRoutePath extends AppRoutePath {}

// Top-level routes
class LandingRoutePath extends AppRoutePath {
  @override
  Uri toUri() => Uri(path: '/landing');
}

class LoginRoutePath extends AppRoutePath {
  @override
  Uri toUri() => Uri(path: '/login');
}

class RegisterRoutePath extends AppRoutePath {
  @override
  Uri toUri() => Uri(path: '/register');
}

class UnknownRoutePath extends AppRoutePath {
  @override
  Uri toUri() => Uri(path: '/404');
}

// Home subroutes
sealed class HomeSubRoutePath extends AuthenticatedRoutePath {}

class HomeRoutePath extends HomeSubRoutePath {
  @override
  Uri toUri() => Uri(path: '/app/home');
}

class HomeDetailRoutePath extends HomeSubRoutePath {
  final String id;
  HomeDetailRoutePath({required this.id});

  @override
  Uri toUri() => Uri(path: '/app/home/detail/$id');
}

// Fav subroutes
sealed class FavSubRoutePath extends AuthenticatedRoutePath {}

class FavRoutePath extends FavSubRoutePath {
  @override
  Uri toUri() => Uri(path: '/app/fav');
}

class FavDetailRoutePath extends FavSubRoutePath {
  final String id;
  FavDetailRoutePath({required this.id});

  @override
  Uri toUri() => Uri(path: '/app/fav/detail/$id');
}

class AddRoutePath extends AuthenticatedRoutePath {
  @override
  Uri toUri() => Uri(path: '/app/add');
}

class SettingsRoutePath extends AuthenticatedRoutePath {
  @override
  Uri toUri() => Uri(path: '/app/settings');
}
