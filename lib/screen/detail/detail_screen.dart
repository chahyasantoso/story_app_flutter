import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/story_detail_provider.dart';
import 'package:story_app/screen/detail/story_detail_item.dart';
import 'package:story_app/screen/detail/story_detail_map.dart';
import 'package:story_app/static/map_utils.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/icon_message.dart';

import '/l10n/app_localizations.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  const DetailScreen({super.key, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> with MapUtils {
  late StoryDetailProvider detailProvider;

  @override
  void initState() {
    super.initState();
    detailProvider = context.read<StoryDetailProvider>();
    Future.microtask(() {
      detailProvider.getStoryDetail(widget.id);
    });
  }

  bool isLocationValid(double? lat, double? lon) =>
      latLngFromDouble(lat, lon) != null;

  AppLocalizations get appLocalizations =>
      AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.titleDetail)),
      body: Consumer<StoryDetailProvider>(
        builder: (context, provider, child) {
          return switch (provider.result) {
            ResultLoading() => Center(child: CircularProgressIndicator()),

            ResultSuccess<Story>(data: final story)
                when !isLocationValid(story.lat, story.lon) =>
              StoryDetailItem(data: story),

            ResultSuccess<Story>(data: final story)
                when isLocationValid(story.lat, story.lon) =>
              StoryDetailMap(data: story),

            ResultError(message: final message) => Center(
              child: IconMessage.error(
                message.toString(),
                button: FilledButton(
                  onPressed: () => provider.getStoryDetail(widget.id),
                  child: Text(appLocalizations.messageTryAgain),
                ),
              ),
            ),
            _ => SizedBox(),
          };
        },
      ),
    );
  }
}
