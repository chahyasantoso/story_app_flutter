import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/location_provider.dart';
import 'package:story_app/provider/story_map_provider.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/screen/detail/story_detail_sheet.dart';
import 'package:story_app/screen/detail/story_map.dart';
import 'package:story_app/static/result_state.dart';

class AddMapScreen extends StatefulWidget {
  final void Function()? onDone;
  const AddMapScreen({super.key, this.onDone});

  @override
  State<AddMapScreen> createState() => _AddMapScreenState();
}

class _AddMapScreenState extends State<AddMapScreen> {
  final defaultLocation = LatLng(-7, 26); // default fallback
  late LocationProvider locationProvider;
  late StoryMapProvider mapProvider;

  @override
  void initState() {
    super.initState();
    locationProvider = context.read<LocationProvider>();
    mapProvider = context.read<StoryMapProvider>();

    initLocation();
    Future.microtask(() async {
      if (mapProvider.location == null) {
        await locationProvider.getCurrentLocation();
        initLocation();
      }
    });
  }

  void initLocation() {
    final state = locationProvider.state;
    if (state is ResultSuccess) {
      final coord = getLatLng(state.data);
      if (coord != null) {
        mapProvider.initLocation(coord);
      }
    }
  }

  void handleTap(LatLng coordinate) {
    mapProvider.location = coordinate;
  }

  LatLng? getLatLng(LocationData data) {
    final (lat, lon) = (data.latitude, data.longitude);
    if (lat == null || lon == null) return null;
    return LatLng(lat, lon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Location")),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, _) {
          final state = locationProvider.state;
          return switch (state) {
            ResultLoading() => const Center(child: CircularProgressIndicator()),
            _ => StoryMap(
              location: mapProvider.location ?? defaultLocation,
              onTap: handleTap,
            ),
          };
        },
      ),
    );
  }
}
