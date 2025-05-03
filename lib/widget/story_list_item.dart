import 'package:flutter/material.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/style/typography/story_text_styles.dart';
import 'package:story_app/widget/favorite_button.dart';
import 'package:story_app/widget/story_network_image.dart';

class StoryListItem extends StatelessWidget {
  final Story data;
  const StoryListItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Positioned.fill(
              child: StoryNetworkImage(
                photoUrl: data.photoUrl,
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
                      data.name,
                      style: StoryTextStyles.titleLarge.copyWith(
                        color: ColorScheme.of(context).onPrimary,
                        shadows: [Shadow(blurRadius: 20)],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  FavoriteButton(data: data),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
