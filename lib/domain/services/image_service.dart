import 'package:story_app/domain/entities/image_data_entity.dart';

abstract class ImageService {
  Future<ImageDataEntity> compress(ImageDataEntity image);
}
