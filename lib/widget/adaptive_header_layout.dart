import 'dart:async';
import 'package:flutter/material.dart';

class AdaptiveHeaderLayout extends StatefulWidget {
  final Widget headerBackground;
  final Widget? headerContent;
  final double headerSize;
  final double minOffset;
  final bool allowScroll;
  final Widget child;

  const AdaptiveHeaderLayout({
    super.key,
    required this.headerBackground,
    this.headerContent,
    this.headerSize = 0.3,
    this.minOffset = 0,
    this.allowScroll = true,
    required this.child,
  });

  @override
  State<AdaptiveHeaderLayout> createState() => _AdaptiveHeaderLayoutState();
}

class _AdaptiveHeaderLayoutState extends State<AdaptiveHeaderLayout> {
  final GlobalKey<NestedScrollViewState> globalKey = GlobalKey();
  late ScrollController outerController;

  @override
  void initState() {
    super.initState();
    outerController = ScrollController(initialScrollOffset: widget.minOffset);
    outerController.addListener(adjustOuterControllerOffset);
  }

  bool isPortrait() {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  void adjustOuterControllerOffset() {
    if (outerController.hasClients && isPortrait()) {
      if (outerController.offset < widget.minOffset) {
        Timer(
          Duration(milliseconds: 0),
          () => outerController.jumpTo(outerController.initialScrollOffset),
        );
      }
    }
  }

  void adjustInnerControllerOffset() {
    if (globalKey.currentState == null) return;

    final innerController = globalKey.currentState!.innerController;
    if (!innerController.hasClients) {
      adjustOuterControllerOffset();
    }
    if (innerController.hasClients && isPortrait()) {
      if (innerController.offset <= 0) {
        adjustOuterControllerOffset();
      } else {
        Timer(
          Duration(milliseconds: 0),
          () => innerController.jumpTo(innerController.offset),
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    adjustInnerControllerOffset();
  }

  @override
  void dispose() {
    super.dispose();
    outerController.dispose();
  }

  Widget buildBackgroundHeader() {
    Widget headerContent = widget.headerContent ?? SizedBox();
    headerContent = SafeArea(child: headerContent);
    return Stack(
      children: [
        Positioned.fill(child: widget.headerBackground),
        if (!isPortrait()) headerContent,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerWidth =
        (MediaQuery.of(context).size.width) * widget.headerSize +
            MediaQuery.of(context).viewPadding.left;
    final headerHeight =
        (MediaQuery.of(context).size.height) * widget.headerSize;
    final pos = isPortrait()
        ? <String, double?>{
            "left": 0.0,
            "top": 0.0,
            "right": 0.0,
            "bottom": null,
            "width": null,
            "height": headerHeight,
          }
        : <String, double?>{
            "left": 0.0,
            "top": 0.0,
            "right": null,
            "bottom": 0.0,
            "width": headerWidth,
            "height": null,
          };

    return Stack(
      children: [
        Positioned(
          left: pos["left"],
          top: pos["top"],
          right: pos["right"],
          bottom: pos["bottom"],
          width: pos["width"],
          height: pos["height"],
          child: buildBackgroundHeader(),
        ),
        Positioned.fill(
          left: pos["width"] ?? 0,
          child: NestedScrollView(
            key: globalKey,
            physics: widget.allowScroll
                ? ScrollPhysics()
                : NeverScrollableScrollPhysics(),
            controller: outerController,
            headerSliverBuilder: (context, bool innerBoxIsScrolled) {
              if (!isPortrait()) return [];
              return [
                SliverAppBar(
                  primary: false,
                  automaticallyImplyLeading: false,
                  expandedHeight: pos["height"],
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.none,
                    background: widget.headerContent,
                  ),
                ),
              ];
            },
            body: widget.child,
          ),
        ),
      ],
    );
  }
}
