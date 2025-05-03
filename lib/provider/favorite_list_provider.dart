import 'package:flutter/material.dart';
import 'package:story_app/data/services/sqlite_service.dart';
import 'package:story_app/static/result_state.dart';

class FavoriteListProvider extends ChangeNotifier {
  final SqliteService _sqliteService;

  FavoriteListProvider(this._sqliteService);

  ResultState _result = ResultNone();
  ResultState get result => _result;

  Future<void> getAll() async {
    _result = ResultLoading();
    notifyListeners();
    try {
      final favorites = await _sqliteService.getAllItems();
      _result = ResultSuccess(
        data: favorites,
        message: "Fetch favorites success",
      );
      notifyListeners();
    } catch (e) {
      debugPrint("Error $e");
      _result = ResultError(
        error: e,
        message: "Failed to fetch favorite",
      );
      notifyListeners();
    }
  }
}
