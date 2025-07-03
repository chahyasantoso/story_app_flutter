import 'package:story_app/domain/entities/image_data_entity.dart';
import 'package:story_app/domain/repositories/story_repository.dart';
import 'package:story_app/domain/services/geocoding_service.dart';
import 'package:story_app/domain/services/image_service.dart';
import 'package:story_app/widget/validation_exception.dart';

class AddStory {
  final StoryRepository _repo;
  final ImageService _imageService;
  final GeocodingService _geocodingService;
  final int _maxFileSize;
  AddStory(
    this._repo,
    this._imageService,
    this._geocodingService, {
    final int maxFileSize = 1024 * 1024,
  }) : _maxFileSize = maxFileSize;

  Future<DomainResult<void>> call(
    ImageDataEntity? imageData,
    String? description,
    String? location,
  ) async {
    if (imageData == null) throw ImageValidationException("Image is missing");
    final compressedImage = await _imageService.compress(imageData);
    if (compressedImage.bytes.lengthInBytes > _maxFileSize) {
      throw ImageValidationException("Image size is too big");
    }

    final desc = description?.trim();
    if (desc == null || desc.isEmpty) {
      throw DescriptionValidationException("Description can't be empty");
    }

    final (lat, lon) = await _geocodingService.parseLocation(location ?? "");

    return _repo.addStory(
      compressedImage.bytes,
      compressedImage.filename,
      desc,
      lat: lat,
      lon: lon,
    );
  }
}
