import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RestaurantAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isBackEnabled;
  final bool isSearchBarEnabled;
  final bool isSearchEnabled;
  final bool isFavoriteEnabled;
  final bool isSettingEnabled;
  final Widget? title;
  const RestaurantAppBar({
    super.key,
    this.isBackEnabled = false,
    this.isSearchBarEnabled = false,
    this.isSearchEnabled = false,
    this.isFavoriteEnabled = false,
    this.isSettingEnabled = false,
    this.title,
  });

  @override
  State<RestaurantAppBar> createState() => _RestaurantAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _RestaurantAppBarState extends State<RestaurantAppBar> {
  void handleSearch(String query) {
    context.read<RestaurantSearchProvider>().searchRestaurantList(query);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: widget.isBackEnabled
          ? IconButton.filledTonal(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            )
          : null,
      title: widget.isSearchBarEnabled
          ? SearchBar(
              autoFocus: true,
              onSubmitted: handleSearch,
            )
          : widget.title,
      actions: [
        if (widget.isSearchEnabled)
          IconButton.filledTonal(
            onPressed: () =>
                Navigator.pushNamed(context, NavigationRoute.search.name),
            icon: Icon(Icons.search_rounded),
          ),
        if (widget.isFavoriteEnabled)
          IconButton.filledTonal(
            onPressed: () =>
                Navigator.pushNamed(context, NavigationRoute.favorite.name),
            icon: Icon(Icons.favorite),
          ),
        if (widget.isSettingEnabled)
          IconButton.filledTonal(
            onPressed: () =>
                Navigator.pushNamed(context, NavigationRoute.settings.name),
            icon: Icon(Icons.settings),
          ),
      ],
    );
  }
}
