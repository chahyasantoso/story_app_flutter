import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/app_auth_provider.dart';
import 'package:story_app/routes/go_router/bottom_nav_widget.dart';
import 'package:story_app/screen/add/add_map_screen.dart';
import 'package:story_app/screen/add/add_post_screen.dart';
import 'package:story_app/screen/detail/detail_screen.dart';
import 'package:story_app/screen/fav/fav_screen.dart';
import 'package:story_app/screen/home/home_screen.dart';
import 'package:story_app/screen/image/image_view_screen.dart';
import 'package:story_app/screen/login/login_screen.dart';
import 'package:story_app/screen/register/register_screen.dart';
import 'package:story_app/screen/settings/settings_screen.dart';
import 'package:story_app/static/auth_state.dart';

final shellKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) {
        return LoginScreen();
      },
      routes: [
        GoRoute(path: "login", redirect: (context, state) => '/'),
        GoRoute(
          path: "register",
          builder: (context, state) {
            return RegisterScreen();
          },
        ),
      ],
    ),

    ShellRoute(
      builder: (context, state, child) {
        return BottomNavWidget(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeScreen(),
          routes: [
            GoRoute(
              path: 'detail/:id',
              builder: (context, state) =>
                  DetailScreen(id: state.pathParameters['id']!),
            ),
          ],
        ),
        GoRoute(
          path: '/fav',
          builder: (context, state) => FavScreen(),
          routes: [
            GoRoute(
              path: 'detail/:id',
              builder: (context, state) =>
                  DetailScreen(id: state.pathParameters['id']!),
            ),
          ],
        ),
        GoRoute(
          path: '/add',
          builder: (context, state) => AddPostScreen(),
          routes: [
            GoRoute(path: 'map', builder: (context, state) => AddMapScreen()),
          ],
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => SettingsScreen(),
        ),
      ],
    ),

    GoRoute(
      path: '/image',
      builder: (context, state) =>
          ImageViewScreen(url: state.uri.queryParameters['url'] ?? ''),
    ),
  ],

  redirect: (context, state) {
    final isLoggedIn =
        context.read<AppAuthProvider>().authState is AuthAuthenticated;

    final publicRoute = ["/login", "/register"];
    final isRoutePublic = publicRoute.contains(state.uri.path);

    return !isLoggedIn
        ? !isRoutePublic
              ? "/"
              : null
        : isRoutePublic
        ? "/home"
        : null;
  },
);
