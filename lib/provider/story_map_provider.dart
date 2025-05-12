import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/safe_change_notifier.dart';

class StoryMapProvider extends SafeChangeNotifier {
  ResultState _state = ResultNone();
  ResultState get state => _state;

  late Completer<GoogleMapController> _completer;
  late Key mapKey;

  StoryMapProvider() {
    retry();
  }

  void retry() async {
    _state = ResultLoading();
    mapKey = UniqueKey();
    notifyListeners();

    _completer = Completer<GoogleMapController>();
    try {
      final controller = await _completer.future.timeout(
        const Duration(seconds: 60),
      );
      _state = ResultSuccess(data: controller);
      notifyListeners();
    } catch (e) {
      _state = ResultError(error: e, message: e.toString());
      notifyListeners();
    }
  }

  void onMapCreated(GoogleMapController controller) async {
    if (!_completer.isCompleted) {
      _completer.complete(controller);
    }
  }
}
