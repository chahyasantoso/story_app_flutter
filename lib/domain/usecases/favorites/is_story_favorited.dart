import 'package:story_app/domain/repositories/favorite_repository.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

class IsStoryFavorited {
  final FavoriteRepository _repo;

  IsStoryFavorited(this._repo);

  Future<bool> call(String id) async {
    final result = await _repo.getItemByStoryId(id);
    return result is DomainResultSuccess;
  }
}
