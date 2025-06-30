import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:story_app/domain/entities/image_data_entity.dart';
import 'package:story_app/domain/services/image_service.dart';

class ImageServiceFlutterImageCompress extends ImageService {
  final int maxFileSize;
  ImageServiceFlutterImageCompress({this.maxFileSize = 1024 * 1024});

  @override
  Future<ImageDataEntity> compress(ImageDataEntity image) async {
    int quality = 90;
    Uint8List? compressedBytes;

    while (quality > 10) {
      compressedBytes = await FlutterImageCompress.compressWithList(
        image.bytes,
        quality: quality,
      );
      if (compressedBytes.lengthInBytes < maxFileSize) {
        return ImageDataEntity(compressedBytes, image.filename);
      }
      quality -= 10;
    }

    return ImageDataEntity(compressedBytes ?? image.bytes, image.filename);
  }
}
