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
  late Completer _completer;

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

  void start([LatLng? position]) async {
    _location = position;
    _state = ResultLoading();
    _mapKey = UniqueKey();
    notifyListeners();

    _completer = Completer();
    try {
      await _completer.future.timeout(const Duration(seconds: 60));
      if (_controller == null) return;
      _state = ResultSuccess(data: _controller);
      notifyListeners();
    } catch (e) {
      _state = ResultError(error: e, message: e.toString());
      notifyListeners();
    }
  }

  void retry() => start(_location);

  void onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }

  void resetState() {
    _location = null;
    _state = ResultNone();
    _completer = Completer();
    _controller = null;
  }
}
