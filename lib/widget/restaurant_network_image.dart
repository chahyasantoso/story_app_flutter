import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:story_app/widget/icon_message.dart';

class RestaurantNetworkImage extends StatelessWidget {
  final String pictureId;
  const RestaurantNetworkImage({super.key, required this.pictureId});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "$pictureId",
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Center(
        child: IconMessage.error("Image loading error"),
      ),
      errorListener: (value) => {},
      fit: BoxFit.cover,
      width: double.infinity,
    );
  }
}
