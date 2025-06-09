import 'package:story_app/domain/usecases/story/add_story.dart';
import 'package:story_app/domain/usecases/story/get_all_stories.dart';
import 'package:story_app/domain/usecases/story/get_story_detail.dart';

class StoryUsecases {
  final AddStory add;
  final GetAllStories getAll;
  final GetStoryDetail getDetail;

  StoryUsecases({
    required this.add,
    required this.getAll,
    required this.getDetail,
  });
}
