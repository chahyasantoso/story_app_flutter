import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/favorite_list_provider.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/icon_message.dart';
import 'package:story_app/screen/home/story_list_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<FavoriteListProvider>().getAll();
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
      appBar: AppBar(
        title: Text(appLocalizations.titleFavorite),
      ),
      body: Consumer<FavoriteListProvider>(
        builder: (context, provider, child) {
          return switch (provider.result) {
            ResultLoading() => Center(
                child: CircularProgressIndicator(),
              ),
            ResultSuccess<List<Story>>(data: final data) => Padding(
                padding: EdgeInsets.all(8),
                child: data.isEmpty
                    ? Center(
                        child: IconMessage.notFound(
                            appLocalizations.messageFavoriteNotFound),
                      )
                    : GridView.builder(
                        scrollDirection:
                            isPortrait ? Axis.vertical : Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isPortrait ? 2 : 1,
                        ),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final story = data[index];
                          return GestureDetector(
                            onTap: () => handleDetail(story.id),
                            child: StoryListItem(data: story),
                          );
                        },
                      ),
              ),
            ResultError(message: final message) => Center(
                child: IconMessage.error(
                  message.toString(),
                  button: FilledButton(
                      onPressed: () => provider.getAll(),
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
