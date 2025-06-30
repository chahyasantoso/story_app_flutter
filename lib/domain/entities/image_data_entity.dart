import 'dart:typed_data';

class ImageDataEntity {
  final Uint8List bytes;
  final String filename;

  const ImageDataEntity(this.bytes, this.filename);
}
