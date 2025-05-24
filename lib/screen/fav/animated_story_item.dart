import 'package:flutter/material.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/screen/home/story_item.dart';

class AnimatedStoryItem extends StatefulWidget {
  final Story data;
  final Duration? animationDuration;
  const AnimatedStoryItem({
    super.key,
    required this.data,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<AnimatedStoryItem> createState() => _AnimatedStoryItemState();
}

class _AnimatedStoryItemState extends State<AnimatedStoryItem>
    with TickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: widget.animationDuration,
  );

  late final animation = CurvedAnimation(
    parent: animationController..value = 1.0,
    curve: Curves.easeInOut,
  );

  final tween = Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero);

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void startAnimation() {
    if (animationController.isAnimating) return;
    animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: tween.animate(animation),
        child: StoryItem(
          data: widget.data,
          animationController: animationController,
          onFavButtonPressed: startAnimation,
        ),
      ),
    );
  }
}
