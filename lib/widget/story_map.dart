import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/l10n/app_localizations.dart';
import 'package:story_app/provider/geocoding_provider.dart';
import 'package:story_app/provider/story_map_provider.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/icon_message.dart';

class StoryMap extends StatefulWidget {
  final LatLng location;
  final void Function()? onMapInit;
  final void Function(GoogleMapController controller)? onMapReady;
  final void Function(LatLng latlon)? onTap;
  final void Function(LatLng latlon)? onLongPress;
  final void Function()? onMarkerTap;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? failureBuilder;

  const StoryMap({
    super.key,
    required this.location,
    this.onMapInit,
    this.onMapReady,
    this.onTap,
    this.onLongPress,
    this.onMarkerTap,
    this.loadingBuilder,
    this.failureBuilder,
  });

  @override
  State<StoryMap> createState() => _StoryMapState();
}

class _StoryMapState extends State<StoryMap> {
  late StoryMapProvider mapProvider;
  late GeocodingProvider geoProvider;

  @override
  void initState() {
    super.initState();
    mapProvider = context.read<StoryMapProvider>();
    geoProvider = context.read<GeocodingProvider>();
    Future.microtask(() {
      widget.onMapInit?.call();
      mapProvider.start(widget.location);
    });
  }

  AppLocalizations get appLocalizations =>
      AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

  LatLng get mapLocation => mapProvider.location ?? widget.location;

  Marker get _marker => Marker(
    markerId: MarkerId(mapLocation.toString()),
    position: mapLocation,
    infoWindow: buildInfoWindow(),
    onTap: handleMarkerTap,
  );

  InfoWindow buildInfoWindow() {
    final geoProvider = context.watch<GeocodingProvider>();
    return switch (geoProvider.state) {
      ResultLoading() => InfoWindow(title: appLocalizations.messageLoading),
      ResultSuccess<Placemark>(data: final place) => InfoWindow(
        title: place.street,
        snippet:
            "${place.subLocality}, ${place.locality}, "
            "${place.postalCode}, ${place.country}",
      ),
      ResultError() => InfoWindow(
        title: appLocalizations.messageAddressNotFound,
        snippet: "${mapLocation.latitude}, ${mapLocation.longitude}",
      ),
      _ => InfoWindow(
        title: appLocalizations.messageGetAddress,
        snippet: "${mapLocation.latitude}, ${mapLocation.longitude}",
      ),
    };
  }

  void handleMarkerTap() {
    geoProvider.getPlacemarkFromLatLng(mapLocation);
    widget.onMarkerTap?.call();
  }

  void handleTap(position) {
    widget.onTap?.call(position);
  }

  void handleMapCreated(GoogleMapController controller) {
    mapProvider.onMapCreated(controller);
    widget.onMapReady?.call(controller);
  }

  @override
  void dispose() {
    mapProvider.resetState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.watch<StoryMapProvider>();
    final state = mapProvider.state;
    final mapLocation = mapProvider.location ?? widget.location;

    return Stack(
      children: [
        GoogleMap(
          key: mapProvider.mapKey,
          onMapCreated: handleMapCreated,
          initialCameraPosition: CameraPosition(target: mapLocation, zoom: 18),
          markers: {_marker},
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
          onTap: handleTap,
          onLongPress: widget.onLongPress,
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
                    appLocalizations.messageMapLoadingError,
                    button: FilledButton(
                      onPressed: mapProvider.retry,
                      child: Text(appLocalizations.messageTryAgain),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
