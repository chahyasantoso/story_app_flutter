import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/favorite_button_provider.dart';
import 'package:story_app/provider/story_list_provider.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/static/snack_bar_utils.dart';
import 'package:story_app/widget/icon_message.dart';
import 'package:story_app/screen/home/story_list_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SnackBarUtils {
  late FavoriteButtonProvider favButtonProvider;

  void _snackBarListener() {
    final resultState = favButtonProvider.result;
    switch (resultState) {
      case ResultError(message: final message):
        showSnackBar(context, message);
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    favButtonProvider = context.read<FavoriteButtonProvider>();
    favButtonProvider.addListener(_snackBarListener);
    Future.microtask(() {
      if (!mounted) return;
      context.read<StoryListProvider>().getAllStories();
    });
  }

  void handleDetail(String id) {
    final appRoute = context.read<AppRoute>();
    appRoute.go("/app/home/detail/$id");
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final appLocalizations =
        AppLocalizations.of(context) ?? lookupAppLocalizations(Locale('en'));

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.titleHome),
      ),
      body: Consumer<StoryListProvider>(
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
                            appLocalizations.messageNotFound),
                      )
                    : RefreshIndicator(
                        onRefresh: provider.getAllStories,
                        child: ListView.builder(
                          scrollDirection:
                              isPortrait ? Axis.vertical : Axis.horizontal,
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
              ),
            ResultError(message: final message) => Center(
                child: IconMessage.error(
                  message.toString(),
                  button: FilledButton(
                      onPressed: () => provider.getAllStories(),
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
