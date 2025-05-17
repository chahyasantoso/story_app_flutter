sealed class AppPath {
  static AppPath fromUri(Uri uri) {
    final segments = uri.pathSegments;
    if (segments.isEmpty) {
      return LoginPath();
    }
    switch (segments.first) {
      case 'login':
        return LoginPath();
      case 'register':
        return RegisterPath();
      case 'app':
        if (segments.length < 2) return HomePath();
        switch (segments[1]) {
          case 'home':
            if (segments.length == 4 &&
                segments[2] == 'detail' &&
                segments[3].isNotEmpty) {
              return HomeDetailPath(id: segments[3]);
            }
            return HomePath();
          case 'fav':
            if (segments.length == 4 &&
                segments[2] == 'detail' &&
                segments[3].isNotEmpty) {
              return FavDetailPath(id: segments[3]);
            }
            return FavPath();
          case 'add':
            if (segments.length == 3 && segments[2] == 'map') {
              return AddMapPath();
            }
            return AddPostPath();
          case 'image':
            final imageUrl = uri.queryParameters['url'];
            if (imageUrl != null && imageUrl.isNotEmpty) {
              return ImageViewPath(url: imageUrl);
            }
          case 'settings':
            return SettingsPath();
        }
        return HomePath();
    }
    return UnknownPath();
  }

  Uri toUri();
}

sealed class AuthenticatedPath extends AppPath {}

// Top-level routes
class LoginPath extends AppPath {
  @override
  Uri toUri() => Uri(path: '/login');
}

class RegisterPath extends AppPath {
  @override
  Uri toUri() => Uri(path: '/register');
}

class UnknownPath extends AppPath {
  @override
  Uri toUri() => Uri(path: '/404');
}

sealed class BottomNavPath extends AuthenticatedPath {}

sealed class HomeSubPath extends BottomNavPath {}

class HomePath extends HomeSubPath {
  @override
  Uri toUri() => Uri(path: '/app/home');
}

class HomeDetailPath extends HomeSubPath {
  final String id;
  HomeDetailPath({required this.id});

  @override
  Uri toUri() => Uri(path: '/app/home/detail/$id');
}

sealed class FavSubPath extends BottomNavPath {}

class FavPath extends FavSubPath {
  @override
  Uri toUri() => Uri(path: '/app/fav');
}

class FavDetailPath extends FavSubPath {
  final String id;
  FavDetailPath({required this.id});

  @override
  Uri toUri() => Uri(path: '/app/fav/detail/$id');
}

sealed class AddSubPath extends AuthenticatedPath {}

class AddPostPath extends AddSubPath {
  @override
  Uri toUri() => Uri(path: '/app/add');
}

class AddMapPath extends AddSubPath {
  @override
  Uri toUri() => Uri(path: '/app/add/map');
}

class SettingsPath extends BottomNavPath {
  @override
  Uri toUri() => Uri(path: '/app/settings');
}

class ImageViewPath extends AuthenticatedPath {
  final String url;
  ImageViewPath({required this.url});

  @override
  Uri toUri() => Uri(path: '/app/image?url=$url');
}
