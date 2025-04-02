import 'package:flutter/widgets.dart';

class StoryTextStyles {
  static const TextStyle _commonStyle = TextStyle(
    height: 1.5,
  );

  static final TextStyle _poppins = _commonStyle.copyWith(
    fontFamily: 'Poppins',
  );

  static final TextStyle _robotoSlab = _commonStyle.copyWith(
    fontFamily: 'RobotoSlab',
  );

  static TextStyle displayLarge = _robotoSlab.copyWith(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -2,
  );

  static TextStyle displayMedium = _robotoSlab.copyWith(
    fontSize: 45,
    fontWeight: FontWeight.w600,
    letterSpacing: -1,
  );

  static TextStyle displaySmall = _robotoSlab.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.w500,
    letterSpacing: -1,
  );

  static TextStyle headlineLarge = _robotoSlab.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -1,
  );

  static TextStyle headlineMedium = _robotoSlab.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    letterSpacing: -1,
  );

  static TextStyle headlineSmall = _robotoSlab.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: -1,
  );

  static TextStyle titleLarge = _robotoSlab.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static TextStyle titleMedium = _robotoSlab.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static TextStyle titleSmall = _robotoSlab.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle bodyLarge = _poppins.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static TextStyle bodyMedium = _poppins.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static TextStyle bodySmall = _poppins.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static TextStyle labelLarge = _robotoSlab.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static TextStyle labelMedium = _robotoSlab.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  static TextStyle labelSmall = _robotoSlab.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );
}
