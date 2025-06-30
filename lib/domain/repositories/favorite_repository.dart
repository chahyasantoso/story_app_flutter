import 'package:story_app/data/model/story.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

abstract class FavoriteRepository {
  Future<DomainResult> getAllItems();
  Future<DomainResult> getItemByStoryId(String id);
  Future<DomainResult> insertItem(Story story);
  Future<DomainResult> removeItemByStoryId(String id);
}
