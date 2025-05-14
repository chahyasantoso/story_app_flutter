import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/favorite_list_provider.dart';
import 'package:story_app/provider/favorite_button_provider.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/style/colors/story_colors.dart';

class FavoriteButton extends StatefulWidget {
  final Story data;
  final Future<void> Function(bool isFavorite)? onTap;
  const FavoriteButton({super.key, required this.data, this.onTap});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late FavoriteButtonProvider _buttonProvider;
  late FavoriteListProvider _listProvider;
  bool _isFavorite = false;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    _listProvider = context.read<FavoriteListProvider>();
    _buttonProvider = context.read<FavoriteButtonProvider>();
    _listProvider.addListener(_getFavorite);
    _getFavorite();
  }

  @override
  void dispose() {
    _listProvider.removeListener(_getFavorite);
    super.dispose();
  }

  void _getFavorite() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isFav = _listProvider.isFavorite(widget.data.id);
      if (!mounted) return;
      setState(() {
        _isFavorite = isFav;
      });
    });
  }

  void handleFavorite() async {
    setState(() {
      _isTapped = true;
    });
    await widget.onTap?.call(_isFavorite);
    if (_isFavorite) {
      await _buttonProvider.removeFavoriteByStoryId(widget.data.id);
      if (_buttonProvider.result is ResultSuccess) {
        _listProvider.removeById(widget.data.id);
      }
    } else {
      await _buttonProvider.addFavorite(widget.data);
      if (_buttonProvider.result is ResultSuccess) {
        _listProvider.addStory(widget.data);
      }
    }
    setState(() {
      _isTapped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.watch<FavoriteButtonProvider>().result is ResultLoading;

    return AnimatedScale(
      duration: Duration(milliseconds: 100),
      scale: isLoading && _isTapped ? 0 : 1,
      curve: Curves.easeInOut,
      child: IconButton.filledTonal(
        icon: _isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
        onPressed: isLoading && _isTapped ? null : handleFavorite,
        iconSize: 30,
        color: StoryColors.orange.color,
      ),
    );
  }
}
