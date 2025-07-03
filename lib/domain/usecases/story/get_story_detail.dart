import 'package:story_app/domain/entities/story_entity.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

class GetStoryDetail {
  final StoryRepository _repo;
  GetStoryDetail(this._repo);

  Future<DomainResult<StoryEntity>> call(String id) {
    return _repo.getStoryDetail(id);
  }
}
