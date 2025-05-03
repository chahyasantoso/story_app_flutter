import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:story_app/data/services/story_api_service.dart';
import 'package:story_app/static/result_state.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:story_app/widget/validation_exception.dart';

class StoryAddProvider extends ChangeNotifier {
  final StoryApiService _apiService;
  StoryAddProvider(this._apiService);

  XFile? _imageFile;
  XFile? get imageFile => _imageFile;
  set imageFile(XFile? image) {
    _result = ResultNone();
    _imageFile = image;
    safeNotifyListeners();
  }

  String? _description;
  String? get description => _description;
  set description(String? text) {
    _result = ResultNone();
    _description = text;
    safeNotifyListeners();
  }

  ResultState _result = ResultNone();
  ResultState get result => _result;

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_isDisposed) notifyListeners();
  }

  XFile _validateImageFile() {
    final imageFile = _imageFile;
    if (imageFile == null) throw ValidationException("Image is missing");
    return imageFile;
  }

  String _validateDescription() {
    final desc = _description;
    if (desc == null) throw ValidationException("Description cannot be empty");
    return desc;
  }

  Future<Uint8List> _compressImage(
    XFile file, {
    int maxFileSize = 1024 * 1024,
  }) async {
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

  Future<void> addStory() async {
    _result = ResultLoading();
    safeNotifyListeners();

    try {
      final imageFile = _validateImageFile();
      final description = _validateDescription();

      final compressedImageBytes = await _compressImage(imageFile);
      final result = await _apiService.addStory(
        compressedImageBytes,
        imageFile.name,
        description,
      );
      _result = ResultSuccess(
        data: null,
        message: result.message,
      );
      safeNotifyListeners();
    } catch (e) {
      _result = ResultError(
        error: e,
        message: e.toString(),
      );
      safeNotifyListeners();
    }
  }
}
