import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:story_app/domain/entities/image_data_entity.dart';
import 'package:story_app/domain/repositories/story_repository.dart';
import 'package:story_app/domain/usecases/story_usecases.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/safe_change_notifier.dart';
import 'package:story_app/widget/validation_exception.dart';

class StoryAddProvider extends SafeChangeNotifier {
  final StoryUsecases _storyUsecases;
  StoryAddProvider(this._storyUsecases);

  XFile? _imageFile;
  XFile? get imageFile => _imageFile;
  set imageFile(XFile? image) {
    _imageFile = image;
    notifyListeners();
  }

  String? _location;
  String? get location => _location;
  set location(String? address) {
    _location = address;
    notifyListeners();
  }

  String? _description;
  String? get description => _description;
  set description(String? text) {
    _description = text;
    notifyListeners();
  }

  ResultState _result = ResultNone();
  ResultState get result => _result;

  void initFields() {
    _imageFile = null;
    _location = null;
    _description = null;
    _result = ResultNone();
  }

  Future<void> addStory() async {
    _result = ResultLoading();
    notifyListeners();
    try {
      final imageFile = _imageFile;
      ImageDataEntity? imageData;
      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        imageData = ImageDataEntity(bytes, imageFile.name);
      }

      final domainResult = await _storyUsecases.add(
        imageData,
        description,
        location,
      );

      switch (domainResult) {
        case DomainResultSuccess(data: final data, message: final message):
          _result = ResultSuccess(data: data, message: message);
          notifyListeners();

        case DomainResultError(message: final message):
          debugPrint(message);
          _result = ResultError(
            error: "error",
            message: "Failed to post story",
          );
          notifyListeners();
      }
    } on ValidationException catch (e) {
      _result = ResultError(error: e, message: e.message);
      notifyListeners();
    }
  }

  void clearError<V extends ValidationException>() {
    if (_result case ResultError(error: final error) when error is V) {
      _result = ResultNone();
      notifyListeners();
    }
  }

  String? getError<V extends ValidationException>() {
    if (_result case ResultError(
      error: final error,
      message: final message,
    ) when error is V) {
      return message;
    }
    return null;
  }
}
