import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app/data/services/story_api_service.dart';
import 'package:story_app/static/result_state.dart';

class StoryDetailProvider extends ChangeNotifier {
  final StoryApiService _apiService;
  StoryDetailProvider(this._apiService);

  ResultState _result = ResultNone();
  ResultState get result => _result;

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_isDisposed) notifyListeners();
  }

  Future<void> getStoryDetail(String id) async {
    _result = ResultLoading();
    safeNotifyListeners();
    try {
      final response = await _apiService.getStoryDetail(id);
      _result = ResultSuccess(
        data: response.story,
        message: response.message,
      );
      safeNotifyListeners();
    } on HttpException catch (e) {
      _result = ResultError(error: e, message: e.message);
      safeNotifyListeners();
    } catch (e) {
      debugPrint("Error $e");
      _result = ResultError(
        error: e,
        message: "Failed to get story detail",
      );
      safeNotifyListeners();
    }
  }
}
