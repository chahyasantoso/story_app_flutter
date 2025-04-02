import 'package:flutter/widgets.dart';
import 'package:restaurant_app/static/error_handler.dart';
import 'package:restaurant_app/static/result.dart';
import '../data/services/api_services.dart';

class RestaurantListProvider extends ChangeNotifier with ErrorHandler {
  final ApiServices _apiServices;

  RestaurantListProvider(
    this._apiServices,
  );

  Result _resultState = NoneState();
  Result get resultState => _resultState;

  Future<void> fetchRestaurantList() async {
    try {
      _resultState = LoadingState();
      notifyListeners();

      final result = await _apiServices.getRestaurantList();
      if (result.error) {
        _resultState = ErrorState(result.message);
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
