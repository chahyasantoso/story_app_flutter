import 'dart:io';
import 'package:flutter/material.dart';
import 'package:story_app/data/services/story_api_service.dart';
import 'package:story_app/static/result_state.dart';

class StoryListProvider extends ChangeNotifier {
  final StoryApiService _apiService;
  StoryListProvider(this._apiService);

  ResultState _result = ResultNone();
  ResultState get result => _result;

  Future<void> getAllStories() async {
    _result = ResultLoading();
    notifyListeners();
    try {
      final response = await _apiService.getAllStories();
      _result = ResultSuccess(
        data: response.listStory,
        message: response.message,
      );
      notifyListeners();
    } on HttpException catch (e) {
      _result = ResultError(error: e, message: e.message);
      notifyListeners();
    } catch (e) {
      debugPrint("Error $e");
      _result = ResultError(
        error: e,
        message: "Failed to get story list",
      );
      notifyListeners();
    }
  }
}
