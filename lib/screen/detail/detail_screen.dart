import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/story_detail_provider.dart';
import 'package:story_app/screen/detail/story_detail_item.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/icon_message.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    final appLocalizations =
        AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.titleDetail),
      ),
      body: Consumer<StoryDetailProvider>(
        builder: (context, provider, child) {
          return switch (provider.result) {
            ResultLoading() => Center(
                child: CircularProgressIndicator(),
              ),
            ResultSuccess<Story>(data: final story) =>
              StoryDetailItem(data: story),
            ResultError(message: final message) => Center(
                child: IconMessage.error(
                  message.toString(),
                  button: FilledButton(
                      onPressed: () => provider.getStoryDetail(widget.id),
                      child: Text(appLocalizations.messageTryAgain)),
                ),
              ),
            _ => SizedBox(),
          };
        },
      ),
    );
  }
}
