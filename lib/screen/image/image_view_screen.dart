import 'package:flutter/material.dart';
import 'package:story_app/widget/story_network_image.dart';

class ImageViewScreen extends StatelessWidget {
  final String url;
  const ImageViewScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: double.infinity,
          child: StoryNetworkImage(photoUrl: url, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
