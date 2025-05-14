import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/story_map_provider.dart';
import 'package:story_app/screen/detail/story_detail_sheet.dart';
import 'package:story_app/static/map_utils.dart';
import 'package:story_app/widget/story_map.dart';

class StoryDetailMap extends StatefulWidget {
  final Story data;
  const StoryDetailMap({super.key, required this.data});

  @override
  State<StoryDetailMap> createState() => _StoryDetailMapState();
}

class _StoryDetailMapState extends State<StoryDetailMap> with MapUtils {
  late LatLng storyLocation;
  late StoryMapProvider mapProvider;
  final sheetController = DraggableScrollableController();
  final minChildSize = 0.15;
  final initialChildSize = 0.5;
  final maxChildSize = 0.9;

  @override
  void initState() {
    super.initState();
    mapProvider = context.read<StoryMapProvider>();
    storyLocation =
        latLngFromDouble(widget.data.lat, widget.data.lon) ?? defaultLatLng;

    sheetController.addListener(() {
      final size = sheetController.size;
      final shouldAnimate =
          isPortrait
              ? size == initialChildSize
              : size == initialChildSize || size == maxChildSize;
      if (shouldAnimate) _animateCamera();
    });
  }

  @override
  void dispose() {
    mapProvider.removeListener(_animateCamera);
    sheetController.dispose();
    super.dispose();
  }

  bool get isPortrait =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  void _animateCamera() async {
    final size = context.size;
    if (size == null) return;

    final dx = isPortrait ? 0.0 : size.width * 0.25;
    final dy = isPortrait ? size.height * 0.25 : 0.0;

    mapProvider.controller?.moveCamera(CameraUpdate.newLatLng(storyLocation));
    mapProvider.controller?.animateCamera(CameraUpdate.scrollBy(dx, dy));
  }

  void _animateSheet() {
    sheetController.animateTo(
      minChildSize,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Listener(
            onPointerDown: (_) => _animateSheet(),
            child: StoryMap(
              location: storyLocation,
              onMarkerTap: _animateCamera,
              onMapReady: (_) {
                _animateCamera();
              },
            ),
          ),
          StoryDetailSheet(
            sheetController: sheetController,
            data: widget.data,
            initialChildSize: initialChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
          ),
        ],
      ),
    );
  }
}
