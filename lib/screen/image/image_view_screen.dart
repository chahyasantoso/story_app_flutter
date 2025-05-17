import 'package:flutter/material.dart';
import 'package:story_app/widget/story_network_image.dart';

class ImageViewScreen extends StatelessWidget {
  final String url;
  const ImageViewScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: SizedBox(
        width: double.infinity,
        child: StoryNetworkImage(photoUrl: url, fit: BoxFit.contain),
      ),
    );
  }
}
