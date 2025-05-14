import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:story_app/l10n/app_localizations.dart';
import 'package:story_app/provider/geocoding_provider.dart';
import 'package:story_app/provider/location_provider.dart';
import 'package:story_app/provider/story_map_provider.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/static/snack_bar_utils.dart';
import 'package:story_app/widget/loading_button.dart';

class LocationFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? text;
  final String? errorText;
  final FocusNode? focusNode;
  final void Function(String value)? onChanged;
  final void Function()? onFocus;
  final void Function()? onLocationButtonTap;
  final void Function()? onMapButtonTap;

  const LocationFormField({
    super.key,
    required this.controller,
    this.text,
    this.errorText,
    this.focusNode,
    this.onChanged,
    this.onFocus,
    this.onLocationButtonTap,
    this.onMapButtonTap,
  });

  @override
  State<LocationFormField> createState() => _LocationFormFieldState();
}

class _LocationFormFieldState extends State<LocationFormField>
    with SnackBarUtils {
  late LocationProvider locationProvider;
  late GeocodingProvider geoProvider;
  late StoryMapProvider mapProvider;

  @override
  void initState() {
    super.initState();
    locationProvider = context.read<LocationProvider>();
    geoProvider = context.read<GeocodingProvider>();
    mapProvider = context.read<StoryMapProvider>();

    widget.focusNode?.addListener(() {
      if (widget.focusNode?.hasFocus ?? false) widget.onFocus?.call();
    });
    mapProvider.addListener(locationListener);
    // ask for permission
  }

  @override
  void dispose() {
    mapProvider.removeListener(locationListener);
    super.dispose();
  }

  void locationListener() {
    final (lat, lon) = (
      mapProvider.location?.latitude,
      mapProvider.location?.longitude,
    );
    if (lat == null || lon == null || !mounted) return;

    final text = "$lat, $lon";
    if (!mounted) return;
    widget.controller.text = text;
  }

  Future<void> getCurrentLocationAddress() async {
    await locationProvider.getCurrentLocation();
    final locationState = locationProvider.state;
    if (locationState is ResultSuccess) {
      final LocationData locationData = locationState.data;
      final (lat, lon) = (locationData.latitude, locationData.longitude);
      if (lat != null && lon != null) {
        await geoProvider.addressFromLatLng(LatLng(lat, lon));
        if (!mounted) return;
        widget.controller.text = switch (geoProvider.state) {
          ResultSuccess(data: final String address) => address,
          ResultError() => "$lat, $lon",
          _ => "",
        };
        if (geoProvider.state is ResultError) {
          showSnackBar(context, "Can't get address, using coordinate");
        }
      }
    } else if (locationProvider.state is ResultError) {
      if (!mounted) return;
      showSnackBar(context, "Can't get location");
    }
  }

  Future<void> handleLocationButtonTap() async {
    await getCurrentLocationAddress();
    widget.onLocationButtonTap?.call();
  }

  void handleMapButtonTap() {
    context.read<AppRoute>().go("/app/add/map");
    widget.onMapButtonTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations =
        AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

    final locationProvider = context.watch<LocationProvider>();
    final geoProvider = context.watch<GeocodingProvider>();

    final isLoading =
        locationProvider.state is ResultLoading ||
        geoProvider.state is ResultLoading;

    return TextFormField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      onChanged: widget.onChanged,
      enabled: !isLoading,
      decoration: InputDecoration(
        labelText: "Location",
        hintText: "Enter address or lat, lon coordinate",
        errorText: widget.errorText,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            IconButton.filledTonal(
              onPressed: handleLocationButtonTap,
              icon:
                  isLoading
                      ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(),
                      )
                      : Icon(Icons.location_searching),
            ),

            IconButton.filledTonal(
              onPressed: handleMapButtonTap,
              icon: Icon(Icons.map_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
