import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app/data/services/story_api_service.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/safe_change_notifier.dart';

class StoryDetailProvider extends SafeChangeNotifier {
  final StoryApiService _apiService;
  StoryDetailProvider(this._apiService);

  ResultState _result = ResultNone();
  ResultState get result => _result;

  Future<void> getStoryDetail(String id) async {
    _result = ResultLoading();
    notifyListeners();
    try {
      final response = await _apiService.getStoryDetail(id);
      _result = ResultSuccess(data: response.story, message: response.message);
      notifyListeners();
    } on HttpException catch (e) {
      _result = ResultError(error: e, message: e.message);
      notifyListeners();
    } catch (e) {
      debugPrint("Error $e");
      _result = ResultError(error: e, message: "Failed to get story detail");
      notifyListeners();
    }
  }
}
