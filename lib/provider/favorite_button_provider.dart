import 'package:flutter/material.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/data/services/sqlite_service.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/safe_change_notifier.dart';

class FavoriteButtonProvider extends SafeChangeNotifier {
  final SqliteService _sqliteService;

  FavoriteButtonProvider(this._sqliteService);

  ResultState _result = ResultNone();
  ResultState get result => _result;

  Future<void> addFavorite(Story story) async {
    _result = ResultLoading();
    notifyListeners();
    try {
      final id = await _sqliteService.insertItem(story);
      if (id == 0) throw Exception();
      _result = ResultSuccess(data: id, message: "Story saved");
      notifyListeners();
    } catch (e) {
      _result = ResultError(error: e, message: "Failed to add favorites");
      notifyListeners();
    }
  }

  Future<void> removeFavoriteByStoryId(String storyId) async {
    _result = ResultLoading();
    notifyListeners();
    try {
      final id = await _sqliteService.removeItemByStoryId(storyId);
      _result = ResultSuccess(
        data: id,
        message: "Story removed from favorites",
      );
      notifyListeners();
    } catch (e) {
      _result = ResultError(error: e, message: "Failed to remove favorites");
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String storyId) async {
    final result = await _sqliteService.getItemByStoryId(storyId);
    return result != null;
  }
}
