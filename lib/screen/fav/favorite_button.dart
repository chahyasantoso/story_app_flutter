import 'package:flutter/material.dart';
import 'package:story_app/style/colors/story_colors.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final void Function()? onPressed;

  const FavoriteButton({super.key, this.isFavorite = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      icon:
          isFavorite
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border),
      onPressed: onPressed,
      iconSize: 30,
      color: StoryColors.orange.color,
    );
  }
}
