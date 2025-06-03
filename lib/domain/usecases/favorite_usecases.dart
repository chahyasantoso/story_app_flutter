import 'package:story_app/domain/usecases/favorites/add_story_to_favorites.dart';
import 'package:story_app/domain/usecases/favorites/get_all_favorite_stories.dart';
import 'package:story_app/domain/usecases/favorites/is_story_favorited.dart';
import 'package:story_app/domain/usecases/favorites/remove_story_from_favorites.dart';

/// usecases itu adalah interaksi dari user terhadap system.
/// misal apa saja yang user bisa lakukan terhadap favorite
/// biasanya bisa dilihat dari repo nya.
/// disini system/application rule diberikan. jadi misal add story
/// maka dia cek dulu apa storynya sudah ada => validation

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
