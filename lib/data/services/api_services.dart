import "dart:convert";
import "dart:io";
import "dart:typed_data";
import "package:http/http.dart" as http;
import "package:restaurant_app/data/model/restaurant_add_review_response.dart";
import "package:restaurant_app/data/model/restaurant_detail_response.dart";
import "package:restaurant_app/data/model/restaurant_list_response.dart";
import "package:restaurant_app/data/model/restaurant_search_response.dart";
import "package:restaurant_app/static/api_url.dart";
import "package:restaurant_app/static/api_exception.dart";
import "package:path_provider/path_provider.dart";

class ApiServices {
  static const String _baseUrl = apiUrl;
  static const String _imageUrl = apiImageUrl;

  Future<RestaurantListResponse> getRestaurantList() async {
    final response = await http.get(Uri.parse("$_baseUrl/list"));

    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException("Failed to load restaurant list");
    }
  }

  Future<RestaurantSearchResponse> searchRestaurant(String query) async {
    final response = await http.get(Uri.parse("$_baseUrl/search?q=$query"));

    if (response.statusCode == 200) {
      return RestaurantSearchResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException("Failed to search restaurant");
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));

    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException("Failed to load restaurant detail");
    }
  }

  Future<RestaurantAddReviewResponse> addRestaurantReview(
    String id,
    String name,
    String review,
  ) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/review"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, String>{
        "id": id,
        "name": name,
        "review": review,
      }),
    );

    if (response.statusCode == 201) {
      return RestaurantAddReviewResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ApiException("Failed to add review");
    }
  }

  Future<String> getBase64RestaurantPicture(String pictureId) async {
    final response = await http.get(Uri.parse("$_imageUrl/$pictureId"));
    final bytes = response.bodyBytes;
    return base64Encode(bytes);
  }

  Future<Uint8List> getRestaurantPicture(String pictureId) async {
    final response = await http.get(Uri.parse("$_imageUrl/$pictureId"));
    final bytes = response.bodyBytes;
    return bytes;
  }

  Future<String> downloadAndSaveRestaurantPicture(String pictureId) async {
    final bytes = await getRestaurantPicture(pictureId);

    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = "${directory.path}/$pictureId";
    final File file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }
}
