import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/safe_change_notifier.dart';

class GeocodingProvider extends SafeChangeNotifier {
  ResultState _state = ResultNone();
  ResultState get state => _state;

  Future<void> addressFromLatLng(LatLng coordinates) async {
    _state = ResultLoading();
    notifyListeners();
    try {
      final result = await placemarkFromCoordinates(
        coordinates.latitude,
        coordinates.longitude,
      );
      if (result.isEmpty) throw Exception("Can't find address");
      final place = result.first;
      final address =
          "${place.street}, ${place.subLocality}, "
          "${place.locality}, ${place.postalCode}, ${place.country}";
      _state = ResultSuccess<String>(data: address);
      notifyListeners();
    } catch (e) {
      _state = ResultError(error: e, message: e.toString());
      notifyListeners();
    }
  }
}
