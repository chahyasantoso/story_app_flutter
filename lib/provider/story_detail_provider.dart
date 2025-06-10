import 'package:flutter/material.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/domain/entities/story_entity.dart';
import 'package:story_app/domain/repositories/story_repository.dart';
import 'package:story_app/domain/usecases/story_usecases.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/safe_change_notifier.dart';

class StoryDetailProvider extends SafeChangeNotifier {
  final StoryUsecases _storyUsecase;
  StoryDetailProvider(this._storyUsecase);

  ResultState _result = ResultNone();
  ResultState get result => _result;

  Future<void> getStoryDetail(String id) async {
    _result = ResultLoading();
    notifyListeners();

    final domainResult = await _storyUsecase.getDetail(id);
    switch (domainResult) {
      case DomainResultSuccess<StoryEntity>(
        data: final storyEntity,
        message: final message,
      ):
        final story = Story.fromEntity(storyEntity);
        _result = ResultSuccess(data: story, message: message);
        notifyListeners();

      case DomainResultError(message: final message):
        debugPrint(message);
        _result = ResultError(
          error: "error",
          message: "Failed to get story detail",
        );
        notifyListeners();

      default:
        return;
    }
  }
}
