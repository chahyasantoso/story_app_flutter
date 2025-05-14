import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/safe_change_notifier.dart';

class GeocodingProvider extends SafeChangeNotifier {
  ResultState _state = ResultNone();
  ResultState get state => _state;

  Future<void> getPlacemarkFromLatLng(LatLng coordinates) async {
    _state = ResultLoading();
    notifyListeners();
    try {
      final result = await placemarkFromCoordinates(
        coordinates.latitude,
        coordinates.longitude,
      );
      if (result.isEmpty) throw Exception("No result");
      final place = result.first;
      _state = ResultSuccess<Placemark>(data: place);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      _state = ResultError(error: e, message: "Can't find address");
      notifyListeners();
    }
  }
}
