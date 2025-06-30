import 'package:geocoding/geocoding.dart';
import 'package:story_app/domain/services/geocoding_service.dart';

class GeocodingServiceGeocoding extends GeocodingService {
  bool validateLatLon(double? lat, double? lon) {
    if (lat == null || lon == null) return false;
    if (lat < -90 || lat > 90) return false;
    if (lon < -180 || lon > 180) return false;
    return true;
  }

  (double?, double?) parseLatLon(String latlon) {
    final parts = latlon.split(',');
    if (parts.length != 2) return (null, null);

    final lat = double.tryParse(parts[0].trim());
    final lon = double.tryParse(parts[1].trim());

    return (lat, lon);
  }

  @override
  Future<(double?, double?)> parseLocation(String location) async {
    try {
      double? lat, lon;
      (lat, lon) = parseLatLon(location);
      if (validateLatLon(lat, lon)) return (lat, lon);

      final result = await locationFromAddress(location);
      if (result.isEmpty) throw Exception("Can't find location");

      final loc = result.first;
      return (loc.latitude, loc.longitude);
    } catch (e) {
      return (null, null);
    }
  }
}
