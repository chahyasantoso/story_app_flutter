import 'dart:io';
import 'package:flutter/material.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/data/services/story_api_service.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/safe_change_notifier.dart';

class StoryListProvider extends SafeChangeNotifier {
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
      _result = ResultError(error: e, message: "Failed to get story list");
      notifyListeners();
    }
  }

  List<Story> _listStory = [];
  int _currentPage = 1;
  final int _pageSize = 5;

  bool _isNextPage = true;
  bool get isNextPage => _isNextPage;

  void reset() {
    _result = ResultNone();
    _listStory = [];
    _currentPage = 1;
    _isNextPage = true;
  }

  Future<void> getNextStories() async {
    if (_result is ResultLoading || !_isNextPage) return;

    _result = ResultLoading();
    if (_currentPage == 1) {
      notifyListeners();
    }

    try {
      final response = await _apiService.getAllStories(
        page: _currentPage,
        size: _pageSize,
      );
      if (response.listStory.length < _pageSize) {
        _isNextPage = false;
      } else {
        _currentPage++;
      }
      _listStory = [..._listStory, ...response.listStory];
      _result = ResultSuccess(data: _listStory, message: response.message);
      notifyListeners();
    } on HttpException catch (e) {
      _result = ResultError(error: e, message: e.message);
      notifyListeners();
    } catch (e) {
      debugPrint("Error $e");
      _result = ResultError(error: e, message: "Failed to get story list");
      notifyListeners();
    }
  }
}
