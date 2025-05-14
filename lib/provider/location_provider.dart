import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/safe_change_notifier.dart';

class LocationProvider extends SafeChangeNotifier {
  final Location _locationService = Location();

  ResultState _state = ResultNone();
  ResultState get state => _state;

  Future<void> getCurrentLocation() async {
    _state = ResultLoading();
    notifyListeners();
    try {
      final locationData = await _locationService.getLocation();
      _state = ResultSuccess(data: locationData);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _state = ResultError(error: e, message: "Can't find location");
      notifyListeners();
    }
  }
}
