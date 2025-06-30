import 'package:story_app/data/model/story.dart';
import 'package:story_app/domain/repositories/favorite_repository.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

class AddStoryToFavorites {
  final FavoriteRepository _repo;
  AddStoryToFavorites(this._repo);

  Future<DomainResult> call(Story story) {
    return _repo.insertItem(story);
  }
}
