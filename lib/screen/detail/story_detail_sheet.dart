import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/screen/detail/story_detail_item.dart';

class StoryDetailSheet extends StatefulWidget {
  final Story data;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final DraggableScrollableController sheetController;

  const StoryDetailSheet({
    super.key,
    required this.data,
    required this.sheetController,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 1,
  });

  @override
  State<StoryDetailSheet> createState() => _StoryDetailSheetState();
}

class _StoryDetailSheetState extends State<StoryDetailSheet> {
  bool get isPortrait =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  double closestSize(double currentSize, List<double> sizes) {
    double closest = sizes.first;
    double minDist = (currentSize - closest).abs();
    for (var point in sizes.skip(1)) {
      final dist = (currentSize - point).abs();
      if (dist < minDist) {
        minDist = dist;
        closest = point;
      }
    }
    return closest;
  }

  void animateTo(double size) {
    widget.sheetController.animateTo(
      size,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onVerticalDragUpdate(details) {
    final size = context.size;
    if (size == null) return;

    final height = size.height;
    final delta = -details.delta.dy / height;
    final newSize = (widget.sheetController.size + delta).clamp(
      widget.minChildSize,
      widget.maxChildSize,
    );
    widget.sheetController.jumpTo(newSize);
  }

  void onVerticalDragEnd(details) {
    final currentSize = widget.sheetController.size;
    final size = closestSize(currentSize, [
      widget.minChildSize,
      widget.initialChildSize,
      widget.maxChildSize,
    ]);
    animateTo(size);
  }

  void onTap() {
    final currentSize = widget.sheetController.size;
    if (currentSize == widget.minChildSize) {
      animateTo(widget.initialChildSize);
    } else if (currentSize == widget.initialChildSize) {
      animateTo(widget.maxChildSize);
    } else {
      animateTo(widget.initialChildSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth * (isPortrait ? 1 : 0.5),
          child: DraggableScrollableSheet(
            controller: widget.sheetController,
            initialChildSize: widget.initialChildSize,
            minChildSize: widget.minChildSize,
            maxChildSize: widget.maxChildSize,
            snap: true,
            builder: (context, scrollController) {
              return PointerInterceptor(
                intercepting: kIsWeb,
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  elevation: 8,
                  child: Column(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onVerticalDragUpdate: onVerticalDragUpdate,
                        onVerticalDragEnd: onVerticalDragEnd,
                        onTap: onTap,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: ColorScheme.of(
                                  context,
                                ).onSurface.withAlpha(100),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: StoryDetailItem(data: widget.data),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
