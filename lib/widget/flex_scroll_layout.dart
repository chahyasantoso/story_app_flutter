import 'package:flutter/material.dart';

class FlexScrollLayout extends StatelessWidget {
  final Widget child1;
  final Widget child2;
  const FlexScrollLayout(
      {super.key, required this.child1, required this.child2});

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return isPortrait ? buildPortraitLayout() : buildLancapeLayout();
  }

  Widget buildPortraitLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            child1,
            child2,
          ],
        ),
      ),
    );
  }

  Widget buildLancapeLayout() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          child1,
          Expanded(
            child: SingleChildScrollView(
              child: child2,
            ),
          ),
        ],
      ),
    );
  }
}
