import 'package:flutter/material.dart';
import 'package:story_app/style/colors/story_colors.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final void Function()? onPressed;
  const FavoriteButton({super.key, required this.isFavorite, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      icon: isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
      onPressed: onPressed,
      iconSize: 30,
      color: StoryColors.orange.color,
    );
  }
}
