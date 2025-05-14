import 'package:story_app/style/colors/story_colors.dart';

enum FlavorType { free, paid }

class FlavorValues {
  final String titleApp;

  const FlavorValues({this.titleApp = "StoryApp (default)"});
}

class FlavorConfig {
  final FlavorType flavor;
  final StoryColors storyColor;
  final String assetBackground;

  final FlavorValues values;
  static FlavorConfig? _instance;

  FlavorConfig({
    this.flavor = FlavorType.paid,
    this.storyColor = StoryColors.green,
    this.assetBackground = "assets/images/background_stars_paid.png",
    this.values = const FlavorValues(),
  }) {
    _instance = this;
  }

  static FlavorConfig get instance => _instance ?? FlavorConfig();
}
