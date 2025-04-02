import 'package:flutter/widgets.dart';
import 'package:restaurant_app/static/error_handler.dart';
import 'package:restaurant_app/static/result.dart';
import '../data/services/api_services.dart';

class RestaurantSearchProvider extends ChangeNotifier with ErrorHandler {
  final ApiServices _apiServices;

  RestaurantSearchProvider(
    this._apiServices,
  );

  Result _resultState = NoneState();
  Result get resultState => _resultState;

  void resetSearchState() {
    _resultState = NoneState();
  }

  Future<void> searchRestaurantList(String query) async {
    try {
      _resultState = LoadingState();
      notifyListeners();

      final result = await _apiServices.searchRestaurant(query);

      if (result.error) {
        _resultState = ErrorState("error from api");
        notifyListeners();
      } else {
        _resultState = SuccessState(result.restaurants);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = ErrorState(handleErrorMessage(e));
      notifyListeners();
    }
  }
}
