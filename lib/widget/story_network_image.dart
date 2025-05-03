import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

class StoryNetworkImage extends StatelessWidget {
  final String photoUrl;
  final BoxFit? fit;
  const StoryNetworkImage({super.key, required this.photoUrl, this.fit});

  @override
  Widget build(BuildContext context) {
    final appLocalizations =
        AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

    return CachedNetworkImage(
      imageUrl: photoUrl,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Center(
        child: Text(appLocalizations.messageImageLoadingError),
      ),
      errorListener: (value) => {},
      fit: fit,
    );
  }
}
