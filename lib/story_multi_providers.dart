import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/repositories/favorite_repository_sqlite.dart';
import 'package:story_app/data/services/location_service.dart';
import 'package:story_app/data/services/shared_preferences_service.dart';
import 'package:story_app/data/services/sqlite_service.dart';
import 'package:story_app/data/services/story_api_service.dart';
import 'package:story_app/data/services/story_auth_service.dart';
import 'package:story_app/domain/repositories/favorite_repository.dart';
import 'package:story_app/domain/usecases/favorite_usecases.dart';
import 'package:story_app/domain/usecases/favorites/add_story_to_favorites.dart';
import 'package:story_app/domain/usecases/favorites/get_all_favorite_stories.dart';
import 'package:story_app/domain/usecases/favorites/is_story_favorited.dart';
import 'package:story_app/domain/usecases/favorites/remove_story_from_favorites.dart';
import 'package:story_app/provider/app_auth_provider.dart';
import 'package:story_app/provider/favorite_list_provider.dart';
import 'package:story_app/provider/favorite_mutation_provider.dart';
import 'package:story_app/provider/geocoding_provider.dart';
import 'package:story_app/provider/location_provider.dart';
import 'package:story_app/provider/settings_provider.dart';
import 'package:story_app/provider/story_list_provider.dart';
import 'package:story_app/routes/app_path.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/static/auth_state.dart';

class StoryMultiProviders extends StatelessWidget {
  final Widget child;
  const StoryMultiProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => SharedPreferencesService()),
        Provider(create: (_) => StoryAuthService()),
        Provider(create: (_) => SqliteService()),
        Provider(create: (_) => LocationService()),
        ChangeNotifierProvider(
          create:
              (context) => AppAuthProvider(
                storyAuthService: context.read<StoryAuthService>(),
                prefService: context.read<SharedPreferencesService>(),
              ),
        ),
        ProxyProvider<AppAuthProvider, StoryApiService>(
          update: (context, authProvider, prev) {
            final service = prev ?? StoryApiService();
            service.token = authProvider.userProfile?.token ?? "";
            return service;
          },
        ),
        ChangeNotifierProvider(
          create:
              (context) => AppRoute(
                redirect: (AppPath path) {
                  final isLoggedIn =
                      context.read<AppAuthProvider>().authState
                          is AuthAuthenticated;
                  return !isLoggedIn
                      ? (path is AuthenticatedPath ? LoginPath() : null)
                      : (path is! AuthenticatedPath ? HomePath() : null);
                },
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => StoryListProvider(context.read<StoryApiService>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  SettingsProvider(context.read<SharedPreferencesService>()),
        ),
        Provider<FavoriteRepository>(
          create:
              (context) =>
                  FavoriteRepositorySqlite(context.read<SqliteService>()),
        ),
        Provider(
          create: (context) {
            final repo = context.read<FavoriteRepository>();
            FavoriteUseCases(
              add: AddStoryToFavorites(repo),
              getAll: GetAllFavoriteStories(repo),
              isFavorite: IsStoryFavorited(repo),
              remove: RemoveStoryFromFavorites(repo),
            );
          },
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  FavoriteMutationProvider(context.read<SqliteService>()),
        ),
        ChangeNotifierProxyProvider<
          FavoriteMutationProvider,
          FavoriteListProvider
        >(
          create:
              (context) =>
                  FavoriteListProvider(context.read<FavoriteUseCases>()),
          update: (context, favMutationProvider, prev) {
            final favListProvider =
                prev ?? FavoriteListProvider(context.read<FavoriteUseCases>());
            favListProvider.onMutation(favMutationProvider);
            return favListProvider;
          },
        ),
        ChangeNotifierProvider(
          create:
              (context) => LocationProvider(context.read<LocationService>()),
        ),
        ChangeNotifierProvider(create: (_) => GeocodingProvider()),
      ],
      child: child,
    );
  }
}
