import 'package:flutter/material.dart';

class FlexScrollLayout extends StatelessWidget {
  final double spacing;
  final double breakpoint;
  final List<Widget> children;

  const FlexScrollLayout({
    super.key,
    this.spacing = 0.0,
    this.breakpoint = 600,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= breakpoint;

        if (isWide) {
          return SizedBox(
            height:
                constraints.maxHeight != double.infinity
                    ? constraints.maxHeight
                    : MediaQuery.of(context).size.height,
            child: Row(
              spacing: spacing,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  children
                      .map(
                        (child) => Expanded(
                          child: SingleChildScrollView(child: child),
                        ),
                      )
                      .toList(),
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              spacing: spacing,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          );
        }
      },
    );
  }
}
