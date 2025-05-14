import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/story_map_provider.dart';
import 'package:story_app/screen/detail/story_detail_sheet.dart';
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
  final minChildSize = 0.15;
  final initialChildSize = 0.5;
  final maxChildSize = 0.9;

  @override
  void initState() {
    super.initState();
    mapProvider = context.read<StoryMapProvider>();
    mapProvider.addListener(_animateCamera);

    sheetController.addListener(() {
      final size = sheetController.size;
      final shouldAnimate =
          isPortrait
              ? size == initialChildSize
              : size == initialChildSize || size == maxChildSize;
      if (shouldAnimate) _animateCamera();
    });

    final lat = widget.data.lat;
    final lon = widget.data.lon;
    final isLocationValid = lat != null && lon != null;
    if (!isLocationValid) return;
    storyLocation = LatLng(lat, lon);
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
    final state = mapProvider.state;
    if (state is ResultSuccess) {
      final size = context.size;
      if (size == null) return;

      final dx = isPortrait ? 0.0 : size.width * 0.25;
      final dy = isPortrait ? size.height * 0.25 : 0.0;

      final GoogleMapController controller = state.data;
      await controller.moveCamera(CameraUpdate.newLatLng(storyLocation));
      await controller.animateCamera(CameraUpdate.scrollBy(dx, dy));
    }
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
            child: StoryMap(location: storyLocation),
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
