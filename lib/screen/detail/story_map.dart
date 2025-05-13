import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/geocoding_provider.dart';
import 'package:story_app/provider/story_map_provider.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/icon_message.dart';

class StoryMap extends StatefulWidget {
  final LatLng location;
  final void Function(LatLng latlon)? onTap;
  final void Function(LatLng latlon)? onLongPress;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? failureBuilder;

  const StoryMap({
    super.key,
    required this.location,
    this.onTap,
    this.onLongPress,
    this.loadingBuilder,
    this.failureBuilder,
  });

  @override
  State<StoryMap> createState() => _StoryMapState();
}

class _StoryMapState extends State<StoryMap> {
  late StoryMapProvider mapProvider;
  late GeocodingProvider geoProvider;

  bool isMapReady = false;

  @override
  void initState() {
    super.initState();
    mapProvider = context.read<StoryMapProvider>();
    geoProvider = context.read<GeocodingProvider>();
  }

  Marker get _marker => Marker(
    markerId: MarkerId(widget.location.toString()),
    position: widget.location,
    infoWindow: buildInfoWindow(),
    onTap: () => geoProvider.addressFromLatLng(widget.location),
  );

  InfoWindow buildInfoWindow() {
    final geoProvider = context.watch<GeocodingProvider>();
    return switch (geoProvider.state) {
      ResultLoading() => InfoWindow(title: "Loading..."),
      ResultSuccess<String>(data: final address) => InfoWindow(title: address),
      ResultError() => InfoWindow(title: "Can't find address"),
      _ => InfoWindow(title: "tap to geocode"),
    };
  }

  //TODO:
  //-perbaiki info window
  //-bikin falvor
  //-bikin animasi

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.watch<StoryMapProvider>();
    final state = mapProvider.state;

    return Stack(
      children: [
        GoogleMap(
          key: mapProvider.mapKey,
          initialCameraPosition: CameraPosition(
            target: widget.location,
            zoom: 18,
          ),
          markers: {_marker},
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
          onMapCreated: mapProvider.onMapCreated,
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
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
