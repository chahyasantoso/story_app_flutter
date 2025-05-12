sealed class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);

  @override
  String toString() => message;
}

class ImageValidationException extends ValidationException {
  ImageValidationException(super.message);
}

class LocationValidationException extends ValidationException {
  LocationValidationException(super.message);
}

class DescriptionValidationException extends ValidationException {
  DescriptionValidationException(super.message);
}
