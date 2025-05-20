import 'dart:ui';
import 'package:flutter/material.dart';

class StoryImage extends StatelessWidget {
  final Widget image;
  const StoryImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: FittedBox(
            fit: BoxFit.cover,
            child: image,
          ),
        ),
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color: Colors.black.withAlpha(150),
              ),
            ),
          ),
        ),
        AspectRatio(
          aspectRatio: 1,
          child: image,
        ),
      ],
    );
  }
}
