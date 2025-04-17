import 'package:flutter/material.dart';
import 'package:story_app/routes/app_route_path.dart';

class AppRouteParser extends RouteInformationParser<AppRoutePath> {
  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    print("restoreRouteInformation: $configuration");
    return RouteInformation(uri: configuration.toUri());
  }

  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    print("parseRouteInformation: ${routeInformation.uri}");
    return AppRoutePath.fromUri(routeInformation.uri);
  }
}
