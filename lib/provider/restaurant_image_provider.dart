import 'package:flutter/widgets.dart';
import 'package:restaurant_app/static/error_handler.dart';
import 'package:restaurant_app/static/result.dart';
import '../data/services/api_services.dart';

class RestaurantImageProvider extends ChangeNotifier with ErrorHandler {
  final ApiServices _apiServices;

  RestaurantImageProvider(
    this._apiServices,
  );

  Result _resultState = NoneState();
  Result get resultState => _resultState;

  Future<void> fetchPicture(String pictureId) async {
    _resultState = LoadingState();
    notifyListeners();

    try {
      final result = await _apiServices.getRestaurantPicture(pictureId);
      _resultState = SuccessState(result);
      notifyListeners();
    } catch (e) {
      _resultState = ErrorState("Error fetching picture");
      notifyListeners();
    }
  }
}
