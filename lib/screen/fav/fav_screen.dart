import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/story.dart';
import 'package:story_app/provider/favorite_button_provider.dart';
import 'package:story_app/provider/favorite_list_provider.dart';
import 'package:story_app/routes/app_route.dart';
import 'package:story_app/static/result_state.dart';
import 'package:story_app/widget/icon_message.dart';
import 'package:story_app/screen/home/story_list_item.dart';
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
                    return buildAnimatedStoryListItem(
                      data[index],
                      Duration(milliseconds: 300),
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

  final Map<String, AnimationController> animationControllers = {};

  @override
  void dispose() {
    for (final controller in animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget buildAnimatedStoryListItem(Story story, Duration duration) {
    AnimationController? controller = animationControllers[story.id];
    if (controller == null) {
      controller = AnimationController(vsync: this, duration: duration);
      animationControllers[story.id] = controller;
    }
    controller.forward();
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: GestureDetector(
          onTap: () => handleDetail(story.id),
          child: StoryListItem(
            data: story,
            onFavButtonTap: (isFavorite) async {
              if (isFavorite) {
                final controller = animationControllers[story.id];
                if (controller == null || controller.isAnimating) return;

                await controller.reverse();

                controller.dispose();
                animationControllers.remove(story.id);
                favListProvider.notifyListeners();
              }
            },
          ),
        ),
      ),
    );
  }
}
