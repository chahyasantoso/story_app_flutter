import 'package:story_app/domain/usecases/favorites/add_story_to_favorites.dart';
import 'package:story_app/domain/usecases/favorites/get_all_favorite_stories.dart';
import 'package:story_app/domain/usecases/favorites/is_story_favorited.dart';
import 'package:story_app/domain/usecases/favorites/remove_story_from_favorites.dart';

class FavoriteUseCases {
  final AddStoryToFavorites add;
  final RemoveStoryFromFavorites remove;
  final GetAllFavoriteStories getAll;
  final IsStoryFavorited isFavorite;

  FavoriteUseCases({
    required this.add,
    required this.remove,
    required this.getAll,
    required this.isFavorite,
  });
}
