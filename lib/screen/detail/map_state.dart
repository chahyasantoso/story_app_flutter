import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Sealed class representing map load states
abstract class MapState {
  const MapState();
}

class Loading extends MapState {
  const Loading();
}

class Success extends MapState {
  final GoogleMapController controller;
  const Success(this.controller);
}

class ErrorState extends MapState {
  final String message;
  const ErrorState(this.message);
}

class MapsState extends ChangeNotifier {
  /// Center coordinate for the map
  final LatLng center = const LatLng(-6.8957473, 107.6337669);

  /// Completer for GoogleMapController; recreated on retry
  late Completer<GoogleMapController> _controllerCompleter;

  /// Key to force GoogleMap rebuild on retry
  late Key mapKey;

  /// Current map load state
  MapState _state = const Loading();
  MapState get state => _state;

  final Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  MapType _mapType = MapType.normal;
  MapType get mapType => _mapType;

  MapsState() {
    retry();
  }

  /// Starts or restarts the map loading sequence
  void retry() {
    // Reset state and data
    _markers.clear();
    _state = const Loading();

    // Generate new map key to force rebuild
    mapKey = UniqueKey();

    notifyListeners();

    // Create a fresh completer
    _controllerCompleter = Completer<GoogleMapController>();

    // Await controller with timeout
    _startMapLoad();
  }

  /// Handles load logic with timeout
  void _startMapLoad() async {
    try {
      final controller = await _controllerCompleter.future
          .timeout(const Duration(seconds: 10));
      // Add default marker
      _markers.add(
        Marker(
          markerId: const MarkerId('dicoding'),
          position: center,
          onTap: () => controller.animateCamera(
            CameraUpdate.newLatLngZoom(center, 18),
          ),
        ),
      );
      _state = Success(controller);
    } on TimeoutException {
      _state = const ErrorState('Map load timed out');
    } catch (e) {
      _state = ErrorState(e.toString());
    }
    notifyListeners();
  }

  /// Called by GoogleMap when ready
  void onMapCreated(GoogleMapController controller) {
    if (!_controllerCompleter.isCompleted) {
      _controllerCompleter.complete(controller);
    }
  }

  void zoomIn() {
    if (_state is Success) {
      (_state as Success).controller.animateCamera(CameraUpdate.zoomIn());
    }
  }

  void zoomOut() {
    if (_state is Success) {
      (_state as Success).controller.animateCamera(CameraUpdate.zoomOut());
    }
  }

  void setMapType(MapType newType) {
    if (_mapType != newType) {
      _mapType = newType;
      notifyListeners();
    }
  }
}
