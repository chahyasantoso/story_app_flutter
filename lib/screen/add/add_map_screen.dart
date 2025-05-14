import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:story_app/l10n/app_localizations.dart';
import 'package:story_app/provider/geocoding_provider.dart';
import 'package:story_app/provider/location_provider.dart';
import 'package:story_app/provider/story_map_provider.dart';
import 'package:story_app/static/map_utils.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/story_map.dart';

class AddMapScreen extends StatefulWidget {
  const AddMapScreen({super.key});

  @override
  State<AddMapScreen> createState() => _AddMapScreenState();
}

class _AddMapScreenState extends State<AddMapScreen> with MapUtils {
  late LocationProvider locationProvider;
  late GeocodingProvider geoProvider;
  late StoryMapProvider mapProvider;

  @override
  void initState() {
    super.initState();
    locationProvider = context.read<LocationProvider>();
    geoProvider = context.read<GeocodingProvider>();
    mapProvider = context.read<StoryMapProvider>();
    Future.microtask(_initLocation);
  }

  void handleTap(LatLng coordinate) {
    mapProvider.location = coordinate;
    Future.delayed(Duration.zero, () async {
      await geoProvider.getPlacemarkFromLatLng(coordinate);
      mapProvider.controller?.showMarkerInfoWindow(
        MarkerId(coordinate.toString()),
      );
    });
  }

  AppLocalizations get appLocalizations =>
      AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.watch<StoryMapProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.titleSelectLocation)),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, _) {
          final state = locationProvider.state;
          return switch (state) {
            ResultLoading() ||
            ResultNone() => const Center(child: CircularProgressIndicator()),
            _ => StoryMap(
              location: mapProvider.location ?? defaultLatLng,
              onMapInit: () => Future.microtask(_initLocation),
              onTap: handleTap,
            ),
          };
        },
      ),
    );
  }

  Future<void> _initLocation() async {
    ResultState state = locationProvider.state;
    if (state is! ResultSuccess) {
      await locationProvider.getCurrentLocation();
      state = locationProvider.state;
    }
    LatLng? coord;
    if (state is ResultSuccess) {
      final LocationData data = state.data;
      coord = latLngFromDouble(data.latitude, data.longitude);
    }
    mapProvider.location = coord;
  }
}
