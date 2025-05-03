import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/favorite_list_provider.dart';
import 'package:story_app/provider/favorite_button_provider.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/style/colors/story_colors.dart';

class FavoriteButton extends StatefulWidget {
  final Story data;
  const FavoriteButton({super.key, required this.data});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late FavoriteButtonProvider _buttonProvider;
  late FavoriteListProvider _listProvider;
  bool _isFavorite = false;

  void _isFavListener() {
    final listState = _listProvider.result;
    if (listState is ResultSuccess) {
      final favList = listState.data as List<Story>;
      final fav = favList.where(
        (favorite) => favorite.id == widget.data.id,
      );
      if (fav.isNotEmpty) {
        setState(() {
          _isFavorite = true;
        });
      } else {
        setState(() {
          _isFavorite = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _buttonProvider = context.read<FavoriteButtonProvider>();
    _listProvider = context.read<FavoriteListProvider>();
    _listProvider.addListener(_isFavListener);
    _isFavListener();
  }

  @override
  void dispose() {
    _listProvider.removeListener(_isFavListener);
    super.dispose();
  }

  void handleFavorite() async {
    if (_isFavorite) {
      await _buttonProvider.removeFavoriteByStoryId(widget.data.id);
      if (_buttonProvider.result is ResultSuccess) {
        setState(() {
          _isFavorite = false;
        });
        _listProvider.getAll();
      }
    } else {
      await _buttonProvider.addFavorite(widget.data);
      if (_buttonProvider.result is ResultSuccess) {
        setState(() {
          _isFavorite = true;
        });
        _listProvider.getAll();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      icon: _isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
      onPressed: handleFavorite,
      iconSize: 30,
      color: StoryColors.orange.color,
    );
  }
}
