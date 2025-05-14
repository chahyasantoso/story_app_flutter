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
  final void Function(CameraPosition position)? onCameraMove;
  final void Function()? onCameraMoveStarted;
  final void Function()? onCameraIdle;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? failureBuilder;

  const StoryMap({
    super.key,
    required this.location,
    this.onTap,
    this.onLongPress,
    this.onCameraIdle,
    this.onCameraMove,
    this.onCameraMoveStarted,
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

  LatLng get mapLocation => mapProvider.location ?? widget.location;

  Marker get _marker => Marker(
    markerId: MarkerId(mapLocation.toString()),
    position: mapLocation,
    infoWindow: buildInfoWindow(),
    onTap: () => geoProvider.addressFromLatLng(mapLocation),
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
  void onMapCreated(controller) {
    mapProvider.onMapCreated(controller);
    mapProvider.location = mapLocation;
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.watch<StoryMapProvider>();
    final state = mapProvider.state;

    return Stack(
      children: [
        GoogleMap(
          key: mapProvider.mapKey,
          onMapCreated: onMapCreated,
          initialCameraPosition: CameraPosition(target: mapLocation, zoom: 18),
          markers: {_marker},
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          onCameraMoveStarted: widget.onCameraMoveStarted,
          onCameraMove: widget.onCameraMove,
          onCameraIdle: widget.onCameraIdle,
        ),
        if (state is ResultLoading)
          widget.loadingBuilder?.call(context) ??
              Container(
                color: ColorScheme.of(context).surfaceContainer,
                child: Center(child: CircularProgressIndicator()),
              ),
        if (state is ResultError)
          widget.failureBuilder?.call(context) ??
              Container(
                color: ColorScheme.of(context).surfaceContainer,
                child: Center(
                  child: IconMessage.error(
                    "Failed to load map",
                    button: FilledButton(
                      onPressed: mapProvider.retry,
                      child: Text("Try again"),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
