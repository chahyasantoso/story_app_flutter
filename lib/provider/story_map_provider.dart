import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/static/map_utils.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/safe_change_notifier.dart';

class StoryMapProvider extends SafeChangeNotifier with MapUtils {
  ResultState _state = ResultNone();
  ResultState get state => _state;

  // sebenernya GoogleMapController nya maunya dimasukkan jadi completer,
  // tapi sudah dicoba kalo di android jadi gak bisa dipakai controllernya,
  // jadi error (platform error pigeon bla bla...)
  // tapi kalo dipassing ke variabel biasa bisa. jadi ya completernya
  // buat loading state aja
  Completer<void>? _completer;
  Key _mapKey = UniqueKey();
  Key get mapKey => _mapKey;

  LatLng? _location;
  LatLng? get location => _location;
  set location(LatLng? newLocation) {
    _location = newLocation;
    notifyListeners();
  }

  GoogleMapController? _controller;
  GoogleMapController? get controller => _controller;

  VoidCallback? _cancelPrevious;

  void initMap([LatLng? position]) async {
    _cancelPrevious?.call();

    bool isCancelled = false;
    _cancelPrevious = () {
      isCancelled = true;
    };

    _location = position;
    _state = ResultLoading();
    _mapKey = UniqueKey();
    notifyListeners();

    _completer = Completer<void>();
    try {
      await _completer?.future.timeout(const Duration(seconds: 60));
      if (_controller == null || isCancelled) return;
      _state = ResultSuccess(data: _controller);
    } catch (e) {
      if (isCancelled) return;
      _state = ResultError(error: e, message: e.toString());
    } finally {
      if (!isCancelled) notifyListeners();
    }
  }

  void retry() => initMap(_location);

  void onMapCreated(GoogleMapController controller) {
    _controller = controller;
    final completer = _completer;
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
  }

  void resetState() {
    _cancelPrevious?.call();
    _location = null;
    _state = ResultNone();
    _completer = null;
    _controller = null;
  }
}
