import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/static/result_state.dart';

class StoryMapProvider extends ChangeNotifier {
  bool _disposed = false;

  StoryMapProvider() {
    retry();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  ResultState _state = ResultNone();
  ResultState get state => _state;

  late Completer<GoogleMapController> _completer;
  late Key mapKey;

  void retry() async {
    _state = ResultLoading();
    mapKey = UniqueKey();
    notifyListeners();

    _completer = Completer<GoogleMapController>();
    try {
      final controller = await _completer.future.timeout(
        const Duration(seconds: 10),
      );
      _state = ResultSuccess(data: controller);
      notifyListeners();
    } catch (e) {
      _state = ResultError(error: e, message: e.toString());
      notifyListeners();
    }
  }

  void onMapCreated(GoogleMapController controller) async {
    if (_disposed) {
      _completer.completeError(Exception("disposed"));
      return;
    }
    if (!_completer.isCompleted) {
      _completer.complete(controller);
    }
  }
}
