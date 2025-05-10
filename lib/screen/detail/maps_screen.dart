import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/screen/detail/map_state.dart';

class MapsScreen extends StatelessWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapsState(),
      child: const _MapsView(),
    );
  }
}

class _MapsView extends StatelessWidget {
  const _MapsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapsState = context.watch<MapsState>();
    final state = mapsState.state;

    Widget overlay;
    if (state is Loading) {
      overlay = const Center(child: CircularProgressIndicator());
    } else if (state is ErrorState) {
      overlay = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.white70,
              padding: const EdgeInsets.all(16),
              child: Text(
                'Error loading map:\n${state.message}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: mapsState.retry,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      overlay = const SizedBox.shrink();
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            key: mapsState.mapKey,
            initialCameraPosition: CameraPosition(
              target: mapsState.center,
              zoom: 18,
            ),
            onMapCreated: mapsState.onMapCreated,
            markers: mapsState.markers,
            mapType: mapsState.mapType,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          overlay,
          // Zoom and retry controls
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'retry-btn',
                  tooltip: 'Retry Map Load',
                  onPressed: mapsState.retry,
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'zoom-in',
                  tooltip: 'Zoom In',
                  onPressed: mapsState.zoomIn,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'zoom-out',
                  tooltip: 'Zoom Out',
                  onPressed: mapsState.zoomOut,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
          // Map type selector
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton.small(
              heroTag: 'map-type',
              tooltip: 'Select Map Type',
              onPressed: null,
              child: PopupMenuButton<MapType>(
                onSelected: mapsState.setMapType,
                offset: const Offset(0, 54),
                icon: const Icon(Icons.layers_outlined),
                itemBuilder:
                    (_) => const [
                      PopupMenuItem(
                        value: MapType.normal,
                        child: Text('Normal'),
                      ),
                      PopupMenuItem(
                        value: MapType.satellite,
                        child: Text('Satellite'),
                      ),
                      PopupMenuItem(
                        value: MapType.terrain,
                        child: Text('Terrain'),
                      ),
                      PopupMenuItem(
                        value: MapType.hybrid,
                        child: Text('Hybrid'),
                      ),
                    ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
