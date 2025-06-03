import 'package:story_app/domain/repositories/favorite_repository.dart';

class RemoveStoryFromFavorites {
  final FavoriteRepository _repo;

  RemoveStoryFromFavorites(this._repo);

  Future<void> call(String id) {
    return _repo.removeItemByStoryId(id);
  }
}
