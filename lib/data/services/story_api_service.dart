import "dart:convert";
import "dart:io";
import "dart:typed_data";

import "package:http/http.dart" as http;
import "package:story_app/data/model/story_add_response.dart";
import "package:story_app/data/model/story_detail_response.dart";
import "package:story_app/data/model/story_list_response.dart";
import "package:story_app/static/api_url.dart";

class StoryApiService {
  String _token;
  StoryApiService([this._token = ""]);

  set token(String token) {
    _token = token;
  }

  Future<StoryAddResponse> addStory(
    Uint8List imageBytes,
    String filename,
    String description, {
    double? lat,
    double? lon,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse("$apiUrl/stories"));
    final multipartFile = http.MultipartFile.fromBytes(
      "photo",
      imageBytes,
      filename: filename,
    );

    final isLatLongValid = (lat != null && lon != null);
    final fields = {
      "description": description,
      if (isLatLongValid) "lat": lat.toString(),
      if (isLatLongValid) "lon": lon.toString(),
    };
    final headers = {
      HttpHeaders.contentTypeHeader: "multipart/form-data",
      HttpHeaders.authorizationHeader: "Bearer $_token",
    };

    request.files.add(multipartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    final streamedResponse = await request.send();
    final responseList = await streamedResponse.stream.toBytes();
    final responseBody = String.fromCharCodes(responseList);

    final jsonBody = jsonDecode(responseBody);
    if (streamedResponse.statusCode == 201) {
      return StoryAddResponse.fromJson(jsonBody);
    } else {
      throw HttpException(jsonBody["message"]);
    }
  }

  Future<StoryListResponse> getAllStories({
    int? page,
    int? size,
    int? location = 0,
  }) async {
    final queryParam = {
      if (page != null) "page": page.toString(),
      if (size != null) "size": size.toString(),
      "location": location.toString(),
    };
    final uri = Uri.parse(apiUrl);
    final response = await http.get(
      Uri.https(uri.authority, "${uri.path}/stories", queryParam),
      headers: {HttpHeaders.authorizationHeader: "Bearer $_token"},
    );

    final jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return StoryListResponse.fromJson(jsonBody);
    } else {
      throw HttpException(jsonBody["message"]);
    }
  }

  Future<StoryDetailResponse> getStoryDetail(String id) async {
    final response = await http.get(
      Uri.parse("$apiUrl/stories/$id"),
      headers: {HttpHeaders.authorizationHeader: "Bearer $_token"},
    );

    final jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return StoryDetailResponse.fromJson(jsonBody);
    } else {
      throw HttpException(jsonBody["message"]);
    }
  }
}
