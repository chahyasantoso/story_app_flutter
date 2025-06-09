import 'package:flutter/rendering.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/domain/entities/story_entity.dart';
import 'package:story_app/domain/repositories/story_repository.dart';
import 'package:story_app/domain/usecases/story_usecases.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/safe_change_notifier.dart';

class StoryListProvider extends SafeChangeNotifier {
  final StoryUsecases _storyUsecase;
  StoryListProvider(this._storyUsecase);

  ResultState _result = ResultNone();
  ResultState get result => _result;

  List<Story> _listStory = [];
  int _currentPage = 1;
  final int _pageSize = 5;

  bool _isNextPage = true;
  bool get isNextPage => _isNextPage;

  Future<void> initList() async {
    _result = ResultNone();
    _listStory = [];
    _currentPage = 1;
    _isNextPage = true;
    await getNextStories();
  }

  Future<void> getNextStories() async {
    if (_result is ResultLoading || !_isNextPage) return;

    _result = ResultLoading();
    if (_currentPage == 1) {
      notifyListeners();
    }

    final response = await _storyUsecase.getAll(
      page: _currentPage,
      size: _pageSize,
    );

    switch (response) {
      case DomainResultSuccess<List<StoryEntity>>(
        data: final listStoryEntity,
        message: final message,
      ):
        final listStory =
            listStoryEntity
                .map((storyEntity) => Story.fromEntity(storyEntity))
                .toList();
        if (listStory.length < _pageSize) {
          _isNextPage = false;
        } else {
          _currentPage++;
        }
        _listStory = [..._listStory, ...listStory];
        _result = ResultSuccess(data: _listStory, message: message);
        notifyListeners();

      case DomainResultError(message: final message):
        debugPrint(message);
        _result = ResultError(
          error: "error",
          message: "Failed to get story list",
        );
        notifyListeners();

      default:
        return;
    }
  }
}
