import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/location_provider.dart';
import 'package:story_app/provider/story_add_provider.dart';
import 'package:story_app/provider/story_map_provider.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/screen/detail/story_detail_sheet.dart';
import 'package:story_app/screen/detail/story_map.dart';
import 'package:story_app/static/result_state.dart';

class AddMapScreen extends StatefulWidget {
  const AddMapScreen({super.key});

  @override
  State<AddMapScreen> createState() => _AddMapScreenState();
}

class _AddMapScreenState extends State<AddMapScreen> {
  LatLng mapCoordinate = LatLng(-7, 26); // default fallback
  late LocationProvider locationProvider;
  late StoryAddProvider addProvider;

  @override
  void initState() {
    super.initState();
    locationProvider = context.read<LocationProvider>();
    addProvider = context.read<StoryAddProvider>();
    initLocation();
  }

  void initLocation() {
    final state = locationProvider.state;
    if (state is ResultSuccess) {
      mapCoordinate = getLatLng(state.data) ?? mapCoordinate;
    } else {
      Future.microtask(() async {
        await locationProvider.getCurrentLocation();
        if (!mounted) return;
        final newState = locationProvider.state;
        if (newState is ResultSuccess) {
          final newCoord = getLatLng(newState.data);
          if (newCoord != null) {
            setState(() {
              mapCoordinate = newCoord;
            });
          }
        }
      });
    }
  }

  void handleTap(LatLng coordinate) {
    setState(() {
      mapCoordinate = coordinate;
    });
  }

  LatLng? getLatLng(LocationData data) {
    final (lat, lon) = (data.latitude, data.longitude);
    if (lat == null || lon == null) return null;
    return LatLng(lat, lon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        actions: [
          FilledButton.icon(
            label: Text("Done"),
            icon: Icon(Icons.done_all_outlined),
            onPressed: () {
              addProvider.location =
                  "${mapCoordinate.latitude}, ${mapCoordinate.longitude}";
              context.read<AppRoute>().goBack();
            },
          ),
        ],
      ),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, _) {
          final state = locationProvider.state;
          return switch (state) {
            ResultLoading() => const Center(child: CircularProgressIndicator()),
            _ => StoryMap(location: mapCoordinate, onTap: handleTap),
          };
        },
      ),
    );
  }
}
