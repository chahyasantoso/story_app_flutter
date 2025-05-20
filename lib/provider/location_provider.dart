import 'package:flutter/material.dart';
import 'package:story_app/data/services/location_service.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/safe_change_notifier.dart';

class LocationProvider extends SafeChangeNotifier {
  final LocationService _locationService;
  LocationProvider(this._locationService);

  ResultState _state = ResultNone();
  ResultState get state => _state;

  Future<void> getCurrentLocation() async {
    _state = ResultLoading();
    notifyListeners();
    try {
      final locationData = await _locationService.getCurrentLocation();
      _state = ResultSuccess(data: locationData);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _state = ResultError(error: e, message: "Can't find location");
      notifyListeners();
    }
  }

  Future<bool> getPermission() async {
    _state = ResultLoading();
    notifyListeners();
    final isPermitted = await _locationService.getPermission();
    if (!isPermitted) {
      final errorMsg = "Permission denied";
      _state = ResultError(error: Exception(errorMsg), message: errorMsg);
      notifyListeners();
      return false;
    }
    return true;
  }
}
