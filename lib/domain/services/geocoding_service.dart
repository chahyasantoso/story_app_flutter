abstract class GeocodingService {
  Future<(double?, double?)> parseLocation(String location);
}
