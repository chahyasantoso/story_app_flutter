import 'restaurant.dart';

class RestaurantAddReviewResponse {
  final bool error;
  final String message;
  final List<CustomerReview> customerReviews;

  RestaurantAddReviewResponse({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory RestaurantAddReviewResponse.fromJson(Map<String, dynamic> json) =>
      RestaurantAddReviewResponse(
        error: json["error"],
        message: json["message"],
        customerReviews: List<CustomerReview>.from(
            json["customerReviews"].map((x) => CustomerReview.fromJson(x))),
      );
}
