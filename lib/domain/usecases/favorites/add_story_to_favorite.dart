import 'package:story_app/data/model/story.dart';
import 'package:story_app/domain/repositories/favorite_repository.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

class AddStoryToFavorite {
  final FavoriteRepository _repo;
  AddStoryToFavorite(this._repo);

  Future<DomainResult<void>> call(Story story) {
    return _repo.insertItem(story);
  }
}
