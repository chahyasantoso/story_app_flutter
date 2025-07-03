import 'package:story_app/domain/entities/story_entity.dart';
import 'package:story_app/domain/repositories/favorite_repository.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

class GetAllFavoriteStories {
  final FavoriteRepository _repo;

  GetAllFavoriteStories(this._repo);

  Future<DomainResult<List<StoryEntity>>> call() {
    return _repo.getAllItems();
  }
}
