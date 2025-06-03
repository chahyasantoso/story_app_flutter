import 'package:story_app/data/model/story.dart';
import 'package:story_app/domain/repositories/favorite_repository.dart';

class DuplicateFavoriteException implements Exception {
  final String message;
  DuplicateFavoriteException([this.message = "Already in favorites"]);

  @override
  String toString() => message;
}

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
