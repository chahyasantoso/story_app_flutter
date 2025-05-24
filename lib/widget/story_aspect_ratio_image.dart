import 'package:flutter/material.dart';

class StoryAspectRatioImage extends StatelessWidget {
  final Widget image;
  final double aspectRatio;
  const StoryAspectRatioImage({
    super.key,
    required this.image,
    this.aspectRatio = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: ColoredBox(color: Colors.black)),
        AspectRatio(aspectRatio: aspectRatio, child: image),
      ],
    );
  }
}
