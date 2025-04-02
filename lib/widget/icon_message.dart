import 'package:flutter/material.dart';
import 'package:story_app/style/colors/story_colors.dart';

class IconMessage extends StatelessWidget {
  final Icon icon;
  final Text text;

  const IconMessage({super.key, required this.icon, required this.text});
  IconMessage.notFound(String text, {super.key})
    : icon = Icon(Icons.search_off, size: 50, color: StoryColors.green.color),
      text = Text(text, textAlign: TextAlign.center);
  IconMessage.error(String text, {super.key})
    : icon = Icon(Icons.close, size: 50, color: Colors.red),
      text = Text(text, textAlign: TextAlign.center);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8.0,
      children: [icon, text],
    );
  }
}
