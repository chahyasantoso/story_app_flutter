import 'package:flutter/material.dart';
import 'package:story_app/routes/app_path.dart';

class AppRouteParser extends RouteInformationParser<AppPath> {
  @override
  RouteInformation? restoreRouteInformation(AppPath configuration) {
    print("restoreRouteInformation: $configuration");
    return RouteInformation(uri: configuration.toUri());
  }

  @override
  Future<AppPath> parseRouteInformation(RouteInformation routeInformation) {
    print("parseRouteInformation: ${routeInformation.uri}");
    return Future.value(AppPath.fromUri(routeInformation.uri));
  }
}
