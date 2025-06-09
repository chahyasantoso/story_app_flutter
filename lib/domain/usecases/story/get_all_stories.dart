import 'package:story_app/domain/repositories/story_repository.dart';

class GetAllStories {
  final StoryRepository _repo;
  GetAllStories(this._repo);

  Future<DomainResult> call({int? page, int? size, int? location = 0}) {
    return _repo.getAllStories(page: page, size: size, location: location);
  }
}
