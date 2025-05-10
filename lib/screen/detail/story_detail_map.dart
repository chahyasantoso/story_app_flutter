import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/story_map_provider.dart';
import 'package:story_app/screen/detail/story_detail_item.dart';
import 'package:story_app/screen/detail/story_map.dart';
import 'package:story_app/static/result_state.dart';

class StoryDetailMap extends StatefulWidget {
  final Story data;
  const StoryDetailMap({super.key, required this.data});

  @override
  State<StoryDetailMap> createState() => _StoryDetailMapState();
}

class _StoryDetailMapState extends State<StoryDetailMap> {
  late LatLng storyLocation;
  late StoryMapProvider mapProvider;
  final sheetController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    final lat = widget.data.lat;
    final lon = widget.data.lon;
    final isLocationValid = lat != null && lon != null;
    if (!isLocationValid) return;
    storyLocation = LatLng(lat, lon);
    mapProvider = context.read<StoryMapProvider>();
    mapProvider.addListener(_cameraListener);
  }

  @override
  void dispose() {
    mapProvider.removeListener(_cameraListener);
    sheetController.dispose();
    super.dispose();
  }

  void _cameraListener() async {
    final state = mapProvider.state;
    if (state is ResultSuccess) {
      final size = context.size;
      if (size == null) return;

      final dx = size.width * 0.25;
      final dy = 0.0;

      final GoogleMapController controller = state.data;
      await controller.moveCamera(CameraUpdate.newLatLng(storyLocation));
      await controller.animateCamera(CameraUpdate.scrollBy(dx, dy));
    }
  }

  bool _allowGesture = false;
  void _setGesture(bool isAllowed) {
    if (_allowGesture == isAllowed) return;
    setState(() {
      _allowGesture = isAllowed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Listener(
            onPointerDown: (_) {
              _setGesture(true);
              sheetController.animateTo(
                0.3,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            onPointerHover: (_) => _setGesture(true),
            child: StoryMap(
              location: storyLocation,
              allowGesture: _allowGesture,
            ),
          ),
          Listener(
            onPointerDown: (_) {
              _setGesture(false);
              _cameraListener();
            },
            onPointerHover: (_) => _setGesture(false),
            child: StoryDetailSheet(
              sheetController: sheetController,
              data: widget.data,
            ),
          ),
        ],
      ),
    );
  }
}

class StoryDetailSheet extends StatefulWidget {
  final Story data;
  final DraggableScrollableController sheetController;
  final void Function()? onTap;
  const StoryDetailSheet({
    super.key,
    required this.data,
    this.onTap,
    required this.sheetController,
  });

  @override
  State<StoryDetailSheet> createState() => _StoryDetailSheetState();
}

class _StoryDetailSheetState extends State<StoryDetailSheet> {
  final double minSize = 0.3;
  final double maxSize = 0.9;
  late StoryMapProvider mapProvider;

  @override
  void initState() {
    super.initState();
    mapProvider = context.read<StoryMapProvider>();
  }

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth * (isPortrait ? 1 : 0.5),
          child: DraggableScrollableSheet(
            controller: widget.sheetController,
            initialChildSize: minSize,
            minChildSize: minSize,
            maxChildSize: maxSize,
            snap: true,
            shouldCloseOnMinExtent: true,
            builder: (context, scrollController) {
              return Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                elevation: 8,
                child: Column(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onVerticalDragUpdate: (details) {
                        final height = context.size!.height;
                        final delta = -details.delta.dy / height;
                        final newSize = (widget.sheetController.size + delta)
                            .clamp(minSize, maxSize);
                        widget.sheetController.jumpTo(newSize);
                      },
                      onVerticalDragEnd: (details) {
                        final currentSize = widget.sheetController.size;
                        final snapSize = closestSize(currentSize, [
                          minSize,
                          maxSize,
                        ]);
                        widget.sheetController.animateTo(
                          snapSize,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      onTap: () {
                        final currentSize = widget.sheetController.size;
                        if (currentSize == minSize) {
                          widget.sheetController.animateTo(
                            maxSize,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          widget.sheetController.animateTo(
                            minSize,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
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
              );
            },
          ),
        );
      },
    );
  }
}
