import 'package:flutter/material.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/data/services/sqlite_service.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/safe_change_notifier.dart';

class FavoriteListProvider extends SafeChangeNotifier {
  final SqliteService _sqliteService;

  FavoriteListProvider(this._sqliteService);

  ResultState _result = ResultNone();
  ResultState get result => _result;

  List<Story> get _favList {
    if (_result case ResultSuccess(data: final favList)) {
      final reversedList = favList.reversed.toList();
      return reversedList;
    }
    return [];
  }

  set _favList(List<Story> newList) {
    final reversedList = newList.reversed.toList();
    _result =
        _result is ResultSuccess ? ResultSuccess(data: reversedList) : _result;
  }

  List<Story> get favList => _favList;

  Future<void> getAll() async {
    _result = ResultLoading();
    notifyListeners();
    try {
      final favorites = await _sqliteService.getAllItems();
      final reversedList = favorites.reversed.toList();

      _result = ResultSuccess(
        data: reversedList,
        message: "Fetch favorites success",
      );
      _favList = favorites;
      notifyListeners();
    } catch (e) {
      debugPrint("Error $e");
      _result = ResultError(error: e, message: "Failed to fetch favorite");
      notifyListeners();
    }
  }

  void removeById(String id) {
    _favList = _favList.where((story) => story.id != id).toList();
    notifyListeners();
  }

  void addStory(Story story) {
    _favList = [..._favList, story];
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favList.where((story) => story.id == id).toList().isNotEmpty;
  }
}
