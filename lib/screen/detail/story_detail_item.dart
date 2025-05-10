import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/style/typography/story_text_styles.dart';
import 'package:story_app/screen/fav/favorite_button.dart';
import 'package:story_app/widget/flex_scroll_layout.dart';
import 'package:story_app/widget/story_image.dart';
import 'package:story_app/widget/story_network_image.dart';

class StoryDetailItem extends StatefulWidget {
  final Story data;
  const StoryDetailItem({super.key, required this.data});

  @override
  State<StoryDetailItem> createState() => _StoryDetailItemState();
}

class _StoryDetailItemState extends State<StoryDetailItem> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: FlexScrollLayout(
            spacing: 16,
            children: [buildImage(), buildDescription()],
          ),
        );
      },
    );
  }

  Widget buildImage() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          StoryImage(
            image: StoryNetworkImage(
              photoUrl: widget.data.photoUrl,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FavoriteButton(data: widget.data),
          ),
        ],
      ),
    );
  }

  Widget buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        DefaultTextStyle(
          style: StoryTextStyles.labelMedium.copyWith(
            color: ColorScheme.of(context).primary,
          ),
          child: Row(
            spacing: 4,
            children: [...buildDateTime(), ...buildLocation(), Spacer()],
          ),
        ),
        RichText(
          text: TextSpan(
            style: StoryTextStyles.bodyMedium.copyWith(
              color: ColorScheme.of(context).onSurface,
            ),
            children: [
              TextSpan(
                text: widget.data.name,
                style: StoryTextStyles.labelLarge,
              ),
              const WidgetSpan(child: SizedBox(width: 8)),
              TextSpan(
                text:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris rutrum dui ut ligula bibendum, vitae porttitor nulla vestibulum. Donec pellentesque lacus at ullamcorper pulvinar. Cras quam metus, eleifend luctus fringilla et, consectetur id ipsum. Curabitur tristique tellus sit amet ex ullamcorper hendrerit. Vivamus ac velit a erat dapibus suscipit. Pellentesque aliquam tempor leo malesuada consequat. Sed in sodales ipsum. Vestibulum vestibulum enim est, id molestie eros fermentum a. Integer interdum urna velit, id mollis massa aliquam non. Curabitur sit amet nulla pretium, efficitur magna eu, ultrices lectus.",
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> buildDateTime() {
    String dateString = DateFormat('dd MMM yyyy').format(widget.data.createdAt);

    return [
      Icon(Icons.calendar_month_outlined),
      Expanded(
        child: Text(dateString, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    ];
  }

  List<Widget> buildLocation() {
    final isLocation = widget.data.lat != null && widget.data.lon != null;
    if (!isLocation) return [];

    return [
      Icon(Icons.map_outlined),
      Expanded(
        child: Text(
          "Lat ${widget.data.lat} Lon ${widget.data.lon}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ];
  }
}
