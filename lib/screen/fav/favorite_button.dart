import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/favorite_list_provider.dart';
import 'package:story_app/provider/favorite_mutation_provider.dart';
import 'package:story_app/style/colors/story_colors.dart';

class FavoriteButton extends StatefulWidget {
  final Story data;
  final bool? setFavorite;
  final void Function()? onPressed;

  const FavoriteButton({
    super.key,
    required this.data,
    this.setFavorite,
    this.onPressed,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late FavoriteMutationProvider favMutationProvider;
  @override
  void initState() {
    super.initState();
    favMutationProvider = context.read<FavoriteMutationProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final favListProvider = context.watch<FavoriteListProvider>();
    final isFavorite = favListProvider.isFavorite(widget.data.id);
    //not sure if i need isFavorite here....

    return IconButton.filledTonal(
      icon:
          isFavorite
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border),
      onPressed:
          widget.onPressed ??
          () => favMutationProvider.toggleFavorite(widget.data),
      iconSize: 30,
      color: StoryColors.orange.color,
    );
  }
}
