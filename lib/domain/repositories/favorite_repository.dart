import 'package:story_app/data/model/story.dart';

abstract class FavoriteRepository {
  Future<List<Story>> getAllItems();
  Future<Story?> getItemByStoryId(String id);
  Future<int> insertItem(Story story);
  Future<int> removeItemByStoryId(String id);
}
