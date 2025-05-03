import 'package:flutter/material.dart';
import 'package:story_app/style/typography/story_text_styles.dart';
import '../colors/story_colors.dart';

class StoryTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: StoryColors.green.color,
      brightness: Brightness.light,
      textTheme: _textTheme,
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorSchemeSeed: StoryColors.green.color,
      brightness: Brightness.dark,
      textTheme: _textTheme,
      useMaterial3: true,
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: StoryTextStyles.displayLarge,
      displayMedium: StoryTextStyles.displayMedium,
      displaySmall: StoryTextStyles.displaySmall,
      headlineLarge: StoryTextStyles.headlineLarge,
      headlineMedium: StoryTextStyles.headlineMedium,
      headlineSmall: StoryTextStyles.headlineSmall,
      titleLarge: StoryTextStyles.titleLarge,
      titleMedium: StoryTextStyles.titleMedium,
      titleSmall: StoryTextStyles.titleSmall,
      bodyLarge: StoryTextStyles.bodyLarge,
      bodyMedium: StoryTextStyles.bodyMedium,
      bodySmall: StoryTextStyles.bodySmall,
      labelLarge: StoryTextStyles.labelLarge,
      labelMedium: StoryTextStyles.labelMedium,
      labelSmall: StoryTextStyles.labelSmall,
    );
  }
}
