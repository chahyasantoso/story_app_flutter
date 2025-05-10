import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/story_map_provider.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/icon_message.dart';

class StoryMap extends StatefulWidget {
  final LatLng location;
  final bool allowGesture;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? failureBuilder;

  const StoryMap({
    super.key,
    required this.location,
    this.allowGesture = true,
    this.loadingBuilder,
    this.failureBuilder,
  });

  @override
  State<StoryMap> createState() => _StoryMapState();
}

class _StoryMapState extends State<StoryMap> {
  late StoryMapProvider mapProvider;
  final Set<Marker> markers = {};
  bool isMapReady = false;

  @override
  void initState() {
    super.initState();
    mapProvider = context.read<StoryMapProvider>();
    final marker = Marker(
      markerId: MarkerId("story"),
      position: widget.location,
    );
    markers.add(marker);
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.watch<StoryMapProvider>();
    final state = mapProvider.state;

    return Stack(
      children: [
        Visibility(
          visible: true,
          child: GoogleMap(
            key: mapProvider.mapKey,
            initialCameraPosition: CameraPosition(
              target: widget.location,
              zoom: 15,
            ),
            onMapCreated: mapProvider.onMapCreated,
            markers: markers,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            webGestureHandling:
                widget.allowGesture
                    ? WebGestureHandling.auto
                    : WebGestureHandling.none,
          ),
        ),
        if (state is ResultLoading)
          widget.loadingBuilder?.call(context) ??
              Center(child: CircularProgressIndicator()),
        if (state is ResultError)
          widget.failureBuilder?.call(context) ??
              Center(
                child: IconMessage.error(
                  "Failed to load map",
                  button: FilledButton(
                    onPressed: mapProvider.retry,
                    child: Text("Try again"),
                  ),
                ),
              ),
      ],
    );
  }
}
