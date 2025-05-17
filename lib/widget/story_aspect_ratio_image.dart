import 'package:flutter/material.dart';

class StoryAspectRatioImage extends StatelessWidget {
  final Widget image;
  final double aspectRatio;
  final void Function()? onTap;
  const StoryAspectRatioImage({
    super.key,
    required this.image,
    this.aspectRatio = 1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Positioned.fill(child: ColoredBox(color: Colors.black)),
          AspectRatio(aspectRatio: 1, child: image),
        ],
      ),
    );
  }
}
