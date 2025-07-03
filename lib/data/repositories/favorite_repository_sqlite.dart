import 'package:story_app/data/model/story.dart';
import 'package:story_app/data/services/favorite_sqlite_service.dart';
import 'package:story_app/domain/entities/story_entity.dart';
import 'package:story_app/domain/repositories/favorite_repository.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

/// implementasi dari repository yang ada di domain.
/// yang ini adlah repository yang pakai sqlite
class FavoriteRepositorySqlite extends FavoriteRepository {
  final FavoriteSqliteService _service;
  FavoriteRepositorySqlite(this._service);

  @override
  Future<DomainResult<List<StoryEntity>>> getAllItems() async {
    try {
      final listStory = await _service.getAllItems();
      final listStoryEntity =
          listStory.map((story) => story.toEntity()).toList();

      return DomainResultSuccess(data: listStoryEntity);
    } catch (e) {
      return DomainResultError(message: e.toString());
    }
  }

  @override
  Future<DomainResult<StoryEntity>> getItemByStoryId(String id) async {
    try {
      final result = await _service.getItemByStoryId(id);
      final storyEntity = result.toEntity();
      return DomainResultSuccess(data: storyEntity);
    } catch (e) {
      return DomainResultError(message: e.toString());
    }
  }

  @override
  Future<DomainResult<void>> insertItem(Story story) async {
    try {
      await _service.insertItem(story);
      return DomainResultSuccess(data: null);
    } catch (e) {
      return DomainResultError(message: e.toString());
    }
  }

  @override
  Future<DomainResult<void>> removeItemByStoryId(String id) async {
    try {
      await _service.removeItemByStoryId(id);
      return DomainResultSuccess(data: null);
    } catch (e) {
      return DomainResultError(message: e.toString());
    }
  }
}
