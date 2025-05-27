import 'package:story_app/data/model/story.dart';
import 'package:story_app/data/services/sqlite_service.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/safe_change_notifier.dart';

enum MutationType { add, remove }

class FavoriteMutationProvider extends SafeChangeNotifier {
  final SqliteService _sqliteService;

  FavoriteMutationProvider(this._sqliteService);

  ResultState _result = ResultNone();
  ResultState get result => _result;

  MutationType? _lastMutation;
  MutationType? get lastMutation => _lastMutation;

  Future<void> addFavorite(Story story) async {
    _lastMutation = MutationType.add;
    _result = ResultLoading();
    notifyListeners();
    try {
      final id = await _sqliteService.insertItem(story);
      if (id == 0) throw Exception();
      _result = ResultSuccess<Story>(data: story, message: "Story saved");
      notifyListeners();
    } catch (e) {
      _result = ResultError(error: e, message: "Failed to add favorites");
      notifyListeners();
    }
  }

  Future<void> removeFavorite(Story story) async {
    _lastMutation = MutationType.remove;
    _result = ResultLoading();
    notifyListeners();
    try {
      await _sqliteService.removeItemByStoryId(story.id);
      _result = ResultSuccess<Story>(
        data: story,
        message: "Story removed from favorites",
      );
      notifyListeners();
    } catch (e) {
      _result = ResultError(error: e, message: "Failed to remove favorites");
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Story story) async {
    final favStory = await _sqliteService.getItemByStoryId(story.id);
    final isFavorite = favStory != null;
    if (isFavorite) {
      await removeFavorite(story);
    } else {
      await addFavorite(story);
    }
  }
}
