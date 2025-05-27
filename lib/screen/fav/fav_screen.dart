import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/favorite_list_provider.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/screen/fav/animated_story_item.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/icon_message.dart';

import '/l10n/app_localizations.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> with TickerProviderStateMixin {
  late FavoriteListProvider favListProvider;

  @override
  void initState() {
    super.initState();
    favListProvider = context.read<FavoriteListProvider>();
    Future.microtask(() {
      favListProvider.getAll();
    });
  }

  void handleDetail(String id) {
    final appRoute = context.read<AppRoute>();
    appRoute.go("/app/fav/detail/$id");
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final appLocalizations =
        AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.titleFavorite)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<FavoriteListProvider>(
          builder: (context, provider, child) {
            return switch (provider.result) {
              ResultLoading() => Center(child: CircularProgressIndicator()),
              ResultSuccess<List<Story>>(data: final data) when data.isEmpty =>
                Center(
                  child: IconMessage.notFound(
                    appLocalizations.messageFavoriteNotFound,
                  ),
                ),
              ResultSuccess<List<Story>>(data: final data)
                  when data.isNotEmpty =>
                GridView.builder(
                  scrollDirection: isPortrait ? Axis.vertical : Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isPortrait ? 2 : 1,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final story = data[index];
                    final id = story.id;
                    return GestureDetector(
                      onTap: () => handleDetail(id),
                      child: AnimatedStoryItem(key: ValueKey(id), data: story),
                    );
                  },
                ),
              ResultError(message: final message) => Center(
                child: IconMessage.error(
                  message.toString(),
                  button: FilledButton(
                    onPressed: () => provider.getAll(),
                    child: Text(appLocalizations.messageTryAgain),
                  ),
                ),
              ),
              _ => SizedBox(),
            };
          },
        ),
      ),
    );
  }
}
