import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/favorite.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/data/services/sqlite_service.dart';

class FavoriteProvider extends ChangeNotifier {
  final SqliteService _service;

  FavoriteProvider(this._service);

  String _message = "";
  String get message => _message;

  List<Favorite> _favoriteList = [];
  List<Favorite> get favoriteList => _favoriteList;

  Future<void> addFavorite(Restaurant restaurant) async {
    try {
      Favorite favorite = Favorite.fromRestaurant(restaurant);
      final resultId = await _service.insertItem(favorite);

      if (resultId == 0) throw Exception();

      final addedFavorite = favorite.copyWith(id: resultId);
      _favoriteList = [..._favoriteList, addedFavorite];
      _message = "Favorite saved";
    } catch (e) {
      _message = "Failed to save favorite";
    }
    notifyListeners();
  }

  Future<void> getAllFavorites() async {
    try {
      _favoriteList = await _service.getAllItems();
      _message = "Favorites loaded";
    } catch (e) {
      _message = "Failed to load favorites";
    }
    notifyListeners();
  }

  Future<void> removeFavoriteByRestaurantId(String restaurantId) async {
    try {
      await _service.removeItemByRestaurantId(restaurantId);
      _favoriteList = _favoriteList
          .where((favorite) => favorite.restaurantId != restaurantId)
          .toList();
      _message = "Favorite removed";
    } catch (e) {
      _message = "Failed to remove favorite";
    }
    notifyListeners();
  }

  bool isFavorite(String restaurantId) {
    final result = _favoriteList.where(
      (favorite) => favorite.restaurantId == restaurantId,
    );
    return result.isNotEmpty;
  }
}
