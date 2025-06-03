import 'package:story_app/data/model/story.dart';
import 'package:story_app/domain/repositories/favorite_repository.dart';

class DuplicateFavoriteException implements Exception {
  final String message;
  DuplicateFavoriteException([this.message = "Already in favorites"]);

  @override
  String toString() => message;
}

/// usecases itu adalah interaksi dari user terhadap system.
/// jadi apa saja yang user bisa lakukan terhadap favorite
/// biasanya bisa dilihat dari repo nya.
/// disini system/application rule diberikan. jadi misal add story
/// maka dia cek dulu apa storynya sudah ada? jadi istilahnya validation
class AddStoryToFavorites {
  final FavoriteRepository _repo;

  AddStoryToFavorites(this._repo);

  Future<void> call(Story story) async {
    final exists = await _repo.getItemByStoryId(story.id);
    if (exists != null) {
      throw DuplicateFavoriteException();
    }

    await _repo.insertItem(story);
  }
}
