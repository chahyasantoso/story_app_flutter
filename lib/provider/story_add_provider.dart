import 'dart:typed_data';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/data/services/story_api_service.dart';
import 'package:story_app/static/result_state.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:story_app/widget/safe_change_notifier.dart';
import 'package:story_app/widget/validation_exception.dart';

class StoryAddProvider extends SafeChangeNotifier {
  final StoryApiService _apiService;
  StoryAddProvider(this._apiService);

  XFile? _imageFile;
  XFile? get imageFile => _imageFile;
  set imageFile(XFile? image) {
    _imageFile = image;
    notifyListeners();
  }

  String? _description;
  String? get description => _description;
  set description(String? text) {
    _description = text;
    notifyListeners();
  }

  String? _location;
  String? get location => _location;
  set location(String? address) {
    _location = address;
    notifyListeners();
  }

  ResultState _result = ResultNone();
  ResultState get result => _result;

  final maxFileSize = 1024 * 1024;
  Future<Uint8List> _compressImage(XFile file) async {
    int quality = 90;
    Uint8List? compressedBytes;
    Uint8List originalBytes = await file.readAsBytes();

    while (quality > 10) {
      compressedBytes = await FlutterImageCompress.compressWithList(
        originalBytes,
        quality: quality,
      );
      if (compressedBytes.lengthInBytes < maxFileSize) {
        return compressedBytes;
      }
      quality -= 10;
    }
    return compressedBytes ?? originalBytes;
  }

  Future<(Uint8List, String)> _validateImageFile() async {
    final imageFile = _imageFile;
    if (imageFile == null) throw ImageValidationException("Image is missing");
    final compressedImageBytes = await _compressImage(imageFile);
    if (compressedImageBytes.lengthInBytes >= maxFileSize) {
      throw ImageValidationException("Image size is too big");
    }
    return (compressedImageBytes, imageFile.name);
  }

  String _validateDescription() {
    final desc = _description;
    if (desc == null || desc.trim().isEmpty) {
      throw DescriptionValidationException("Description cannot be empty");
    }
    return desc;
  }

  LatLng? _tryParseLatLng(String input) {
    final parts = input.split(',');
    if (parts.length != 2) return null;

    final lat = double.tryParse(parts[0].trim());
    final lon = double.tryParse(parts[1].trim());

    if (lat == null || lon == null) return null;
    if (lat < -90 || lat > 90) return null;
    if (lon < -180 || lon > 180) return null;
    return LatLng(lat, lon);
  }

  Future<LatLng?> _tryParseAddress(String input) async {
    try {
      final result = await locationFromAddress(input);
      if (result.isEmpty) return null;
      final loc = result.first;
      return LatLng(loc.latitude, loc.longitude);
    } catch (e) {
      return null;
    }
  }

  Future<(double?, double?)> _validateLocation() async {
    final loc = _location;
    if (loc == null || loc.trim().isEmpty) {
      return (null, null);
    }
    LatLng? coordinates = _tryParseLatLng(loc);
    coordinates ??= await _tryParseAddress(loc);
    if (coordinates == null) {
      throw LocationValidationException("Can't find address");
    }
    return (coordinates.latitude, coordinates.longitude);
  }

  Future<void> addStory() async {
    _result = ResultLoading();
    notifyListeners();
    try {
      final (imageBytes, filename) = await _validateImageFile();
      final (lat, lon) = await _validateLocation();
      final description = _validateDescription();

      final result = await _apiService.addStory(
        imageBytes,
        filename,
        description,
        lat: lat,
        lon: lon,
      );
      _result = ResultSuccess(data: null, message: result.message);
      notifyListeners();
    } catch (e) {
      _result = ResultError(error: e, message: e.toString());
      notifyListeners();
    }
  }

  void reset() {
    _result = ResultNone();
    notifyListeners();
  }
}
