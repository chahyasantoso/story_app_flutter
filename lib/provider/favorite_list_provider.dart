import 'package:flutter/material.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/domain/usecases/favorite_usecases.dart';
import 'package:story_app/provider/favorite_mutation_provider.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/safe_change_notifier.dart';

class FavoriteListProvider extends SafeChangeNotifier {
  final FavoriteUseCases _favoriteUseCase;
  FavoriteListProvider(this._favoriteUseCase);

  ResultState _result = ResultNone();
  ResultState get result => _result;

  List<Story> _favList = [];
  List<Story> get favList => _favList.reversed.toList();

  Future<void> initList() async {
    _result = ResultNone();
    _favList = [];
    await getAll();
  }

  Future<void> getAll() async {
    if (_result is ResultLoading) return;

    _result = ResultLoading();
    notifyListeners();
    try {
      _favList = await _favoriteUseCase.getAll();
      _result = ResultSuccess(
        data: favList,
        message: "Fetch favorites success",
      );
      notifyListeners();
    } catch (e) {
      debugPrint("Error $e");
      _result = ResultError(error: e, message: "Failed to fetch favorite");
      notifyListeners();
    }
  }

  void onMutation(FavoriteMutationProvider mutationProvider) {
    final mutationResult = mutationProvider.result;
    if (mutationResult is! ResultSuccess) return;

    final Story story = mutationResult.data;
    switch (mutationProvider.lastMutation) {
      case MutationType.add:
        _favList = [..._favList, story];
      case MutationType.remove:
        _favList = _favList.where((s) => s.id != story.id).toList();
      default:
        return;
    }
    _result = ResultSuccess(
      data: favList,
      message: (_result as ResultSuccess).message,
    );
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favList.any((story) => story.id == id);
  }
}
