import 'package:flutter/material.dart';
import 'package:story_app/style/typography/story_text_styles.dart';

class Section extends StatelessWidget {
  final Widget? title;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Widget? child;
  const Section({
    super.key,
    this.title,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0),
    this.color,
    this.child,
  });

  factory Section.text({
    required String text,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16.0),
    Color? color,
    Widget? child,
  }) {
    return Section(
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(text),
      ),
      padding: padding,
      color: color,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final headlineSmall = StoryTextStyles.headlineSmall.copyWith(
      color: ColorScheme.of(context).primary,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
              style: headlineSmall,
              child: title ?? SizedBox(),
            ),
            child ?? SizedBox(),
          ],
        ),
      ),
    );
  }
}
