import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/favorite_button_provider.dart';
import 'package:story_app/provider/favorite_list_provider.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/style/colors/story_colors.dart';

class FavoriteButton extends StatefulWidget {
  final Story data;
  final void Function(Function toggleFavorite)? onInit;
  final void Function()? onPressed;
  const FavoriteButton({
    super.key,
    required this.data,
    this.onInit,
    this.onPressed,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late FavoriteListProvider _favListProvider;
  late FavoriteButtonProvider _favButtonProvider;

  @override
  void initState() {
    super.initState();
    _favListProvider = context.read<FavoriteListProvider>();
    _favButtonProvider = context.read<FavoriteButtonProvider>();
    widget.onInit?.call(_toggleFavorite);
  }

  void _toggleFavorite() async {
    final isFavorite = _favListProvider.isFavorite(widget.data.id);
    if (isFavorite) {
      await _favButtonProvider.removeFavoriteByStoryId(widget.data.id);
      if (_favButtonProvider.result is ResultSuccess) {
        _favListProvider.removeById(widget.data.id);
      }
    } else {
      await _favButtonProvider.addFavorite(widget.data);
      if (_favButtonProvider.result is ResultSuccess) {
        _favListProvider.addStory(widget.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final favListProvider = context.watch<FavoriteListProvider>();
    final isFavorite = favListProvider.isFavorite(widget.data.id);

    return IconButton.filledTonal(
      icon: isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
      onPressed: widget.onPressed ?? _toggleFavorite,
      iconSize: 30,
      color: StoryColors.orange.color,
    );
  }
}
