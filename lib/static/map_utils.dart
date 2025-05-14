import 'package:google_maps_flutter/google_maps_flutter.dart';

mixin MapUtils {
  final defaultLatLng = LatLng(-7, 112);

  LatLng? latLngFromDouble(double? lat, double? lon) {
    if (lat == null || lon == null) return null;
    if (lat < -90 || lat > 90) return null;
    if (lon < -180 || lon > 180) return null;
    return LatLng(lat, lon);
  }

  LatLng? parseLatLng(String input) {
    final parts = input.split(',');
    if (parts.length != 2) return null;

    final lat = double.tryParse(parts[0].trim());
    final lon = double.tryParse(parts[1].trim());
    return latLngFromDouble(lat, lon);
  }
}
