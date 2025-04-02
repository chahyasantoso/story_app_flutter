import 'package:flutter/widgets.dart';
import 'package:restaurant_app/static/error_handler.dart';
import 'package:restaurant_app/static/result.dart';
import '../data/services/api_services.dart';

class ReviewListProvider extends ChangeNotifier with ErrorHandler {
  final ApiServices _apiServices;

  ReviewListProvider(
    this._apiServices,
  );

  Result _resultState = NoneState();
  Result get resultState => _resultState;

  void resetReviewState() {
    _resultState = NoneState();
  }

  Future<void> addReview(String id, String name, String review) async {
    try {
      _resultState = LoadingState();
      notifyListeners();

      final result = await _apiServices.addRestaurantReview(id, name, review);
      if (result.error) {
        _resultState = ErrorState(result.message);
        notifyListeners();
      } else {
        _resultState = SuccessState(result.customerReviews);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = ErrorState(handleErrorMessage(e));
      notifyListeners();
    }
  }
}
