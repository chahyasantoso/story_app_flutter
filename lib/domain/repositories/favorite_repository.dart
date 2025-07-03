import 'package:story_app/data/model/story.dart';
import 'package:story_app/domain/entities/story_entity.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

abstract class FavoriteRepository {
  Future<DomainResult<List<StoryEntity>>> getAllItems();
  Future<DomainResult<StoryEntity>> getItemByStoryId(String id);
  Future<DomainResult<void>> insertItem(Story story);
  Future<DomainResult<void>> removeItemByStoryId(String id);
}
