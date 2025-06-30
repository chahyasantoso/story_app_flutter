import 'package:story_app/domain/repositories/favorite_repository.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

class RemoveStoryFromFavorites {
  final FavoriteRepository _repo;

  RemoveStoryFromFavorites(this._repo);

  Future<DomainResult> call(String id) {
    return _repo.removeItemByStoryId(id);
  }
}
