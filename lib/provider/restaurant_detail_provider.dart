import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/model/restaurant_detail_response.dart';
import 'package:restaurant_app/static/error_handler.dart';
import 'package:restaurant_app/static/result.dart';
import '../data/services/api_services.dart';

class RestaurantDetailProvider extends ChangeNotifier with ErrorHandler {
  final ApiServices _apiServices;

  RestaurantDetailProvider(
    this._apiServices,
  );

  Result _resultState = NoneState();
  Result get resultState => _resultState;

  Future<void> fetchRestaurantDetail(String id) async {
    try {
      _resultState = LoadingState();
      notifyListeners();

      final RestaurantDetailResponse result =
          await _apiServices.getRestaurantDetail(id);

      if (result.error) {
        _resultState = ErrorState(result.message);
        notifyListeners();
      } else {
        _resultState = SuccessState(result.restaurant);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = ErrorState(handleErrorMessage(e));
      notifyListeners();
    }
  }
}
