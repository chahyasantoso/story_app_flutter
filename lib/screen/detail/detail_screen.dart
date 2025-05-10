import 'package:flutter/material.dart';
import 'package:story_app/provider/story_map_provider.dart';
import 'package:story_app/screen/detail/maps_screen.dart';
import 'package:story_app/screen/detail/story_detail_map.dart';
import '/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/story_detail_provider.dart';
import 'package:story_app/screen/detail/story_detail_item.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/icon_message.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  const DetailScreen({super.key, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<StoryDetailProvider>().getStoryDetail(widget.id);
    });
  }

  bool isLocationValid(double? lat, double? lon) => lat != null && lon != null;

  @override
  Widget build(BuildContext context) {
    final appLocalizations =
        AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

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
              ChangeNotifierProvider(
                create: (_) => StoryMapProvider(),
                child: StoryDetailMap(data: story),
              ),
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
