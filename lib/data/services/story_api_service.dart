import "dart:convert";
import "dart:io";
import "dart:typed_data";
import "package:http/http.dart" as http;
import "package:story_app/data/model/story_add_response.dart";
import "package:story_app/data/model/story_detail_response.dart";
import "package:story_app/data/model/story_list_response.dart";
import "package:story_app/data/model/login_response.dart";
import "package:story_app/data/model/register_response.dart";

class StoryApiService {
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";

  Future<RegisterResponse> registerUser(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/register"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, String>{
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return RegisterResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to register user");
    }
  }

  Future<LoginResponse> loginUser(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/login"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to login user");
    }
  }

  Future<StoryAddResponse> addStory(
    String token,
    String description,
    Uint8List imageBytes, {
    double? lat,
    double? long,
  }) async {
    final isLatLongValid = (lat != null && long != null);
    final response = await http.post(
      Uri.parse("$_baseUrl/stories"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(<String, dynamic>{
        "description": description,
        "photo": base64Encode(imageBytes),
        if (isLatLongValid) "lat": lat,
        if (isLatLongValid) "long": long,
      }),
    );

    if (response.statusCode == 201) {
      return StoryAddResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add story");
    }
  }

  Future<StoryListResponse> getAllStories(
    String token, {
    int? page,
    int? size,
    int? location = 0,
  }) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/stories?page=$page&size=$size&location=$location"),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return StoryListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load story list");
    }
  }

  Future<StoryDetailResponse> getStoryDetail(
    String token,
    String id,
  ) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/stories/$id"),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return StoryDetailResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load story detail");
    }
  }
}
