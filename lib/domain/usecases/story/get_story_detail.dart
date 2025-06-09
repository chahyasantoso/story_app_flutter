import 'package:story_app/domain/repositories/story_repository.dart';

class GetStoryDetail {
  final StoryRepository _repo;
  GetStoryDetail(this._repo);

  Future<DomainResult> call(String id) {
    return _repo.getStoryDetail(id);
  }
}
