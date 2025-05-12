import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:universal_html/html.dart' as html;

class LocationService {
  final Location _location;

  LocationService() : _location = Location();

  Future<bool> getPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw Exception("Location service is not enabled");
      }
    }

    final permissionStatus =
        kIsWeb
            ? await _checkLocationPermissionOnWeb()
            : await _location.hasPermission();
    return switch (permissionStatus) {
      PermissionStatus.deniedForever => false,
      PermissionStatus.denied => switch (await _location.requestPermission()) {
        PermissionStatus.granted => true,
        PermissionStatus.grantedLimited => true,
        _ => false,
      },
      _ => true,
    };
  }

  Future<PermissionStatus> _checkLocationPermissionOnWeb() async {
    html.PermissionStatus? status = await html.window.navigator.permissions
        ?.query({'name': 'geolocation'});
    switch (status?.state) {
      case 'granted':
        return PermissionStatus.granted;
      case 'prompt':
        return PermissionStatus.denied;
      case 'denied':
      default:
        return PermissionStatus.deniedForever;
    }
  }

  Future<LocationData> getCurrentLocation() async {
    return await _location.getLocation();
  }
}
