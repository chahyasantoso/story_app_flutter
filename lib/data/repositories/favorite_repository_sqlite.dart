import 'package:story_app/data/model/story.dart';
import 'package:story_app/data/services/favorite_sqlite_service.dart';
import 'package:story_app/domain/repositories/favorite_repository.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

/// implementasi dari repository yang ada di domain.
/// yang ini adlah repository yang pakai sqlite
class FavoriteRepositorySqlite extends FavoriteRepository {
  final FavoriteSqliteService _service;
  FavoriteRepositorySqlite(this._service);

  @override
  Future<DomainResult> getAllItems() async {
    try {
      final result = await _service.getAllItems();
      return DomainResultSuccess(data: result);
    } catch (e) {
      return DomainResultError(message: e.toString());
    }
  }

  @override
  Future<DomainResult> getItemByStoryId(String id) async {
    try {
      final result = await _service.getItemByStoryId(id);
      return DomainResultSuccess(data: result);
    } catch (e) {
      return DomainResultError(message: e.toString());
    }
  }

  @override
  Future<DomainResult> insertItem(Story story) async {
    try {
      final insertedId = await _service.insertItem(story);
      return DomainResultSuccess(data: insertedId);
    } catch (e) {
      return DomainResultError(message: e.toString());
    }
  }

  @override
  Future<DomainResult> removeItemByStoryId(String id) async {
    try {
      final removedId = await _service.removeItemByStoryId(id);
      return DomainResultSuccess(data: removedId);
    } catch (e) {
      return DomainResultError(message: e.toString());
    }
  }
}
