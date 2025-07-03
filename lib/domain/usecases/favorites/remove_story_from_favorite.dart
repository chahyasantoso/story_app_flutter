import 'package:story_app/domain/repositories/favorite_repository.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

class RemoveStoryFromFavorite {
  final FavoriteRepository _repo;

  RemoveStoryFromFavorite(this._repo);

  Future<DomainResult<void>> call(String id) {
    return _repo.removeItemByStoryId(id);
  }
}
