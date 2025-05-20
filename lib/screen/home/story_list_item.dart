import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/favorite_button_provider.dart';
import 'package:story_app/provider/favorite_list_provider.dart';
import 'package:story_app/screen/fav/favorite_button.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/style/typography/story_text_styles.dart';
import 'package:story_app/widget/story_network_image.dart';

class StoryListItem extends StatefulWidget {
  final Story data;
  final AnimationController? animationController;
  final void Function()? onFavButtonPressed;
  const StoryListItem({
    super.key,
    required this.data,
    this.animationController,
    this.onFavButtonPressed,
  });

  @override
  State<StoryListItem> createState() => _StoryListItemState();
}

class _StoryListItemState extends State<StoryListItem> {
  late FavoriteListProvider _favListProvider;
  late FavoriteButtonProvider _favButtonProvider;

  @override
  void initState() {
    super.initState();
    _favListProvider = context.read<FavoriteListProvider>();
    _favButtonProvider = context.read<FavoriteButtonProvider>();
    widget.animationController?.addListener(_toggleFavorite);
  }

  @override
  void dispose() {
    widget.animationController?.removeListener(_toggleFavorite);
    super.dispose();
  }

  AnimationStatus get animationStatus =>
      widget.animationController?.status ?? AnimationStatus.completed;
  bool get isAnimationDone =>
      animationStatus.isDismissed || animationStatus.isCompleted;

  void _toggleFavorite() async {
    if (!isAnimationDone) return;

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

    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Positioned.fill(
              child: StoryNetworkImage(
                photoUrl: widget.data.photoUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.data.name,
                      style: StoryTextStyles.titleLarge.copyWith(
                        color: ColorScheme.of(context).onPrimary,
                        shadows: [Shadow(blurRadius: 20)],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  FavoriteButton(
                    isFavorite: isFavorite,
                    onPressed: widget.onFavButtonPressed ?? _toggleFavorite,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
