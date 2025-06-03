import 'package:story_app/data/model/story.dart';
import 'package:story_app/domain/repositories/favorite_repository.dart';

class GetAllFavoriteStories {
  final FavoriteRepository _repo;

  GetAllFavoriteStories(this._repo);

  Future<List<Story>> call() {
    return _repo.getAllItems();
  }
}
