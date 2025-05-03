import 'package:flutter/material.dart';
import 'package:story_app/routes/app_path.dart';

class AppRouteParser extends RouteInformationParser<AppPath> {
  @override
  RouteInformation? restoreRouteInformation(AppPath configuration) {
    print("restoreRouteInformation: $configuration");
    return RouteInformation(uri: configuration.toUri());
  }

  @override
  Future<AppPath> parseRouteInformation(
      RouteInformation routeInformation) async {
    print("parseRouteInformation: ${routeInformation.uri}");
    return AppPath.fromUri(routeInformation.uri);
  }
}
