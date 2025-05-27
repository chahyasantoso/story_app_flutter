import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/favorite_mutation_provider.dart';
import 'package:story_app/screen/fav/favorite_button.dart';
import 'package:story_app/style/typography/story_text_styles.dart';
import 'package:story_app/widget/story_aspect_ratio_image.dart';
import 'package:story_app/widget/story_network_image.dart';

class StoryItem extends StatefulWidget {
  final Story data;
  final AnimationController? animationController;
  final void Function()? onFavButtonPressed;
  final bool showName;
  const StoryItem({
    super.key,
    required this.data,
    this.animationController,
    this.onFavButtonPressed,
    this.showName = true,
  });

  @override
  State<StoryItem> createState() => _StoryItemState();
}

class _StoryItemState extends State<StoryItem> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.animationController?.addStatusListener(_waitForAnimationStatus);
  }

  @override
  void dispose() {
    widget.animationController?.removeStatusListener(_waitForAnimationStatus);
    super.dispose();
  }

  void _waitForAnimationStatus(AnimationStatus status) async {
    final isAnimationDone = status.isDismissed || status.isCompleted;
    if (!isAnimationDone) return;

    final favMutationProvider = context.read<FavoriteMutationProvider>();
    await favMutationProvider.toggleFavorite(widget.data);

    _resetState(status);
  }

  void _resetState(AnimationStatus status) {
    widget.animationController?.removeStatusListener(_waitForAnimationStatus);
    if (status.isDismissed) {
      widget.animationController?.value = 1.0;
    } else if (status.isCompleted) {
      widget.animationController?.value = 0.0;
    }
    widget.animationController?.addStatusListener(_waitForAnimationStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          StoryAspectRatioImage(
            image: StoryNetworkImage(
              photoUrl: widget.data.photoUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            bottom: null,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child:
                        widget.showName
                            ? Text(
                              widget.data.name,
                              style: StoryTextStyles.titleLarge.copyWith(
                                color: ColorScheme.of(context).onPrimary,
                                shadows: [Shadow(blurRadius: 20)],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                            : SizedBox(),
                  ),
                  FavoriteButton(
                    data: widget.data,
                    onPressed: widget.onFavButtonPressed,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
