import 'package:story_app/data/model/story.dart';
import 'package:story_app/data/services/sqlite_service.dart';
import 'package:story_app/domain/repositories/favorite_repository.dart';

/// implementasi dari repository yang ada di domain.
/// yang ini adlah repository yang pakai sqlite
class FavoriteRepositorySqlite extends FavoriteRepository {
  final SqliteService _service;
  FavoriteRepositorySqlite(this._service);

  @override
  Future<List<Story>> getAllItems() {
    return _service.getAllItems();
  }

  @override
  Future<Story?> getItemByStoryId(String id) {
    return _service.getItemByStoryId(id);
  }

  @override
  Future<int> insertItem(Story story) async {
    return _service.insertItem(story);
  }

  @override
  Future<int> removeItemByStoryId(String id) {
    return _service.removeItemByStoryId(id);
  }
}
