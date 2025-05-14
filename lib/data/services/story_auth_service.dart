import "dart:convert";
import "dart:io";

import "package:http/http.dart" as http;
import "package:story_app/data/model/login_response.dart";
import "package:story_app/data/model/register_response.dart";
import "package:story_app/static/api_url.dart";

class StoryAuthService {
  Future<RegisterResponse> registerUser(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$apiUrl/register"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    final jsonBody = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return RegisterResponse.fromJson(jsonBody);
    } else {
      throw HttpException(jsonBody["message"]);
    }
  }

  Future<LoginResponse> loginUser(String email, String password) async {
    // return LoginResponse(
    //   error: false,
    //   message: "ok",
    //   loginResult: LoginResult(userId: "01", name: "Chahya", token: "x"),
    // );
    final response = await http.post(
      Uri.parse("$apiUrl/login"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8",
      },
      body: jsonEncode({"email": email, "password": password}),
    );

    final jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonBody);
    } else {
      throw HttpException(jsonBody["message"]);
    }
  }
}
