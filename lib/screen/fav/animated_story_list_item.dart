import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/favorite_list_provider.dart';
import 'package:story_app/screen/home/story_list_item.dart';

class AnimatedStoryListItem extends StatefulWidget {
  final Story data;
  final Duration? animationDuration;
  const AnimatedStoryListItem({
    super.key,
    required this.data,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedStoryListItem> createState() => _AnimatedStoryListItemState();
}

class _AnimatedStoryListItemState extends State<AnimatedStoryListItem>
    with TickerProviderStateMixin {
  late final FavoriteListProvider favListProvider =
      context.read<FavoriteListProvider>();

  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: widget.animationDuration,
  );

  late final animation = CurvedAnimation(
    parent: animationController..forward(),
    curve: Curves.easeInOut,
  );

  final tween = Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero);

  @override
  void dispose() {
    print("disposed");
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: tween.animate(animation),
        child: StoryListItem(
          data: widget.data,
          onFavButtonTap: (isFavorite) async {
            print("Fav tap ${widget.data.id}");
            if (isFavorite) {
              if (animationController.isAnimating) return;
              await animationController.reverse();
            }
          },
        ),
      ),
    );
  }
}
