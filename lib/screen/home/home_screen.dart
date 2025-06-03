import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/favorite_list_provider.dart';
import 'package:story_app/provider/favorite_mutation_provider.dart';
import 'package:story_app/provider/story_add_provider.dart';
import 'package:story_app/provider/story_list_provider.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/screen/home/story_item.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/static/snack_bar_utils.dart';
import 'package:story_app/widget/icon_message.dart';

import '/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SnackBarUtils {
  late FavoriteListProvider favListProvider;
  late FavoriteMutationProvider favMutationProvider;
  late StoryListProvider listProvider;
  late StoryAddProvider addProvider;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    favListProvider = context.read<FavoriteListProvider>();
    favMutationProvider = context.read<FavoriteMutationProvider>();
    listProvider = context.read<StoryListProvider>();
    addProvider = context.read<StoryAddProvider>();
    scrollController = ScrollController();

    favMutationProvider.addListener(_snackBarListener);
    addProvider.addListener(_addPostListener);
    scrollController.addListener(_endOfListListener);

    Future.microtask(() {
      favListProvider.initList();
      listProvider.initList();
    });
  }

  @override
  void dispose() {
    favMutationProvider.removeListener(_snackBarListener);
    addProvider.removeListener(_addPostListener);
    scrollController.dispose();
    super.dispose();
  }

  void _snackBarListener() {
    final resultState = favMutationProvider.result;
    switch (resultState) {
      case ResultError(message: final message):
        showSnackBar(context, message);
      default:
    }
  }

  void _endOfListListener() {
    final isEndOfList =
        scrollController.position.pixels >=
        scrollController.position.maxScrollExtent;
    if (isEndOfList) {
      listProvider.getNextStories();
    }
  }

  void _addPostListener() {
    if (addProvider.result is ResultSuccess) {
      scrollController.jumpTo(scrollController.initialScrollOffset);
      listProvider.initList();
    }
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
      appBar: AppBar(title: Text(appLocalizations.titleHome)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<StoryListProvider>(
          builder: (context, provider, child) {
            return switch (provider.result) {
              ResultLoading() => Center(child: CircularProgressIndicator()),
              ResultSuccess<List<Story>>(data: final data) when data.isEmpty =>
                Center(
                  child: IconMessage.notFound(appLocalizations.messageNotFound),
                ),
              ResultSuccess<List<Story>>(data: final data)
                  when data.isNotEmpty =>
                RefreshIndicator(
                  onRefresh: listProvider.initList,
                  child: ListView.builder(
                    key: PageStorageKey("storyList"),
                    controller: scrollController,
                    scrollDirection:
                        isPortrait ? Axis.vertical : Axis.horizontal,
                    itemCount: data.length + (provider.isNextPage ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == data.length) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final story = data[index];
                      return GestureDetector(
                        onTap: () => handleDetail(story.id),
                        child: StoryItem(data: story),
                      );
                    },
                  ),
                ),
              ResultError(message: final message) => Center(
                child: IconMessage.error(
                  message.toString(),
                  button: FilledButton(
                    onPressed: listProvider.getNextStories,
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
