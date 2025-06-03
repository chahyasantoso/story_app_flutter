import 'package:story_app/data/model/story.dart';
import 'package:story_app/domain/usecases/favorite_usecases.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/safe_change_notifier.dart';

enum MutationType { add, remove }

class FavoriteMutationProvider extends SafeChangeNotifier {
  final FavoriteUseCases _favoriteUseCase;

  FavoriteMutationProvider(this._favoriteUseCase);

  ResultState _result = ResultNone();
  ResultState get result => _result;

  MutationType? _lastMutation;
  MutationType? get lastMutation => _lastMutation;

  Future<void> addFavorite(Story story) async {
    _result = ResultLoading();
    notifyListeners();
    try {
      await _favoriteUseCase.add(story);
      _result = ResultSuccess<Story>(data: story, message: "Story saved");
      _lastMutation = MutationType.add;
      notifyListeners();
    } catch (e) {
      _result = ResultError(error: e, message: "Failed to add favorites");
      notifyListeners();
    }
  }

  Future<void> removeFavorite(Story story) async {
    _result = ResultLoading();
    notifyListeners();
    try {
      await _favoriteUseCase.remove(story.id);
      _result = ResultSuccess<Story>(
        data: story,
        message: "Story removed from favorites",
      );
      _lastMutation = MutationType.remove;
      notifyListeners();
    } catch (e) {
      _result = ResultError(error: e, message: "Failed to remove favorites");
      notifyListeners();
    }
  }

  /// note: this can be extracted to a usecase
  Future<void> toggleFavorite(Story story) async {
    final isFavorite = await _favoriteUseCase.isFavorite(story.id);
    if (isFavorite) {
      await removeFavorite(story);
    } else {
      await addFavorite(story);
    }
  }
}
