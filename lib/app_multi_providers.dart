import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/repositories/favorite_repository_sqlite.dart';
import 'package:story_app/data/repositories/story_repository_cache.dart';
import 'package:story_app/data/repositories/user_repository_cache.dart';
import 'package:story_app/data/services/favorite_sqlite_service.dart';
import 'package:story_app/data/services/geocoding_service_geocoding.dart';
import 'package:story_app/data/services/image_service_flutter_image_compress.dart';
import 'package:story_app/data/services/location_service.dart';
import 'package:story_app/data/services/shared_preferences_service.dart';
import 'package:story_app/data/services/story_api_service.dart';
import 'package:story_app/data/services/story_auth_service.dart';
import 'package:story_app/data/services/story_sqlite_service.dart';
import 'package:story_app/domain/repositories/favorite_repository.dart';
import 'package:story_app/domain/repositories/story_repository.dart';
import 'package:story_app/domain/repositories/user_repository.dart';
import 'package:story_app/domain/usecases/favorite_usecases.dart';
import 'package:story_app/domain/usecases/favorites/add_story_to_favorite.dart';
import 'package:story_app/domain/usecases/favorites/get_all_favorite_stories.dart';
import 'package:story_app/domain/usecases/favorites/is_story_favorited.dart';
import 'package:story_app/domain/usecases/favorites/remove_story_from_favorite.dart';
import 'package:story_app/domain/usecases/story/add_story.dart';
import 'package:story_app/domain/usecases/story/get_all_stories.dart';
import 'package:story_app/domain/usecases/story/get_story_detail.dart';
import 'package:story_app/domain/usecases/story_usecases.dart';
import 'package:story_app/domain/usecases/user/load_user.dart';
import 'package:story_app/domain/usecases/user/login_user.dart';
import 'package:story_app/domain/usecases/user/logout_user.dart';
import 'package:story_app/domain/usecases/user/register_user.dart';
import 'package:story_app/domain/usecases/user_usecases.dart';
import 'package:story_app/provider/app_auth_provider.dart';
import 'package:story_app/provider/favorite_list_provider.dart';
import 'package:story_app/provider/favorite_mutation_provider.dart';
import 'package:story_app/provider/geocoding_provider.dart';
import 'package:story_app/provider/location_provider.dart';
import 'package:story_app/provider/settings_provider.dart';
import 'package:story_app/provider/story_detail_provider.dart';
import 'package:story_app/provider/story_list_provider.dart';
import 'package:story_app/routes/app_path.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/static/auth_state.dart';

class AppMultiProviders extends StatelessWidget {
  final Widget child;
  const AppMultiProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => SharedPreferencesService()),
        Provider(create: (_) => StoryAuthService()),
        Provider(create: (_) => FavoriteSqliteService()),
        Provider(create: (_) => LocationService()),

        Provider<UserRepository>(
          create:
              (context) => UserRepositoryCache(
                context.read<StoryAuthService>(),
                context.read<SharedPreferencesService>(),
              ),
        ),
        Provider(
          create: (context) {
            final repo = context.read<UserRepository>();
            return UserUsecases(
              loginUser: LoginUser(repo),
              registerUser: RegisterUser(repo),
              logoutUser: LogoutUser(repo),
              loadUser: LoadUser(repo),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) => AppAuthProvider(context.read<UserUsecases>()),
        ),
        ProxyProvider<AppAuthProvider, StoryApiService>(
          update: (context, authProvider, prev) {
            final service = prev ?? StoryApiService();
            service.token = authProvider.user?.token ?? "";
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

        Provider(create: (context) => StorySqliteService()),
        Provider<StoryRepository>(
          create:
              (context) => StoryRepositoryCache(
                context.read<StoryApiService>(),
                context.read<StorySqliteService>(),
              ),
        ),
        Provider(
          create: (context) {
            final repo = context.read<StoryRepository>();
            return StoryUsecases(
              add: AddStory(
                repo,
                ImageServiceFlutterImageCompress(),
                GeocodingServiceGeocoding(),
              ),
              getAll: GetAllStories(repo),
              getDetail: GetStoryDetail(repo),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) => StoryListProvider(context.read<StoryUsecases>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => StoryDetailProvider(context.read<StoryUsecases>()),
        ),

        Provider<FavoriteRepository>(
          create:
              (context) => FavoriteRepositorySqlite(
                context.read<FavoriteSqliteService>(),
              ),
        ),
        Provider(
          create: (context) {
            final repo = context.read<FavoriteRepository>();
            return FavoriteUseCases(
              add: AddStoryToFavorite(repo),
              getAll: GetAllFavoriteStories(repo),
              isFavorite: IsStoryFavorited(repo),
              remove: RemoveStoryFromFavorite(repo),
            );
          },
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  FavoriteMutationProvider(context.read<FavoriteUseCases>()),
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
              (context) =>
                  SettingsProvider(context.read<SharedPreferencesService>()),
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
