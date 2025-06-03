import 'package:story_app/domain/repositories/favorite_repository.dart';

class IsStoryFavorited {
  final FavoriteRepository _repo;

  IsStoryFavorited(this._repo);

  Future<bool> call(String id) async {
    final story = await _repo.getItemByStoryId(id);
    return story != null;
  }
}
