import 'dart:io';
import 'package:story_app/static/api_exception.dart';

mixin ErrorHandler {
  String handleErrorMessage(Exception e) {
    return switch (e) {
      ApiException() => e.toString(),
      SocketException() => "Failed to fetch, check your internet connection",
      _ => "Ooops, something's wrong",
    };
  }
}
